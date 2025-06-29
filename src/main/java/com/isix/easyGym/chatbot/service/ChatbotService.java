package com.isix.easyGym.chatbot.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.isix.easyGym.chatbot.dto.OpenRouterRequestDTO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Collections;

@Service
public class ChatbotService {

    private static final Logger log = LoggerFactory.getLogger(ChatbotService.class);

    private final WebClient webClient;
    private final ObjectMapper objectMapper;

    @Value("${openrouter.api.key}")
    private String openRouterApiKey;

    private static final String OPENROUTER_API_URL = "https://openrouter.ai/api/v1/chat/completions";
    private static final String MODEL_NAME = "google/gemma-3-4b-it:free";

    @Autowired
    public ChatbotService(WebClient.Builder webClientBuilder, ObjectMapper objectMapper) {
        this.webClient = webClientBuilder.baseUrl(OPENROUTER_API_URL).build();
        this.objectMapper = objectMapper;
    }

    @Async // 중요: 이 메소드를 별도의 스레드에서 비동기적으로 실행
    public void streamChatResponse(String question, SseEmitter emitter) {
        OpenRouterRequestDTO.Message userMessage = new OpenRouterRequestDTO.Message("user", question);
        OpenRouterRequestDTO request = new OpenRouterRequestDTO(
                MODEL_NAME,
                Collections.singletonList(userMessage),
                true
        );

        webClient.post()
                .header(HttpHeaders.AUTHORIZATION, "Bearer " + openRouterApiKey)
                .contentType(MediaType.APPLICATION_JSON)
                .bodyValue(request)
                .retrieve()
                .bodyToFlux(String.class) // 응답을 Flux<String>으로 받음
                .doOnComplete(emitter::complete) // 스트림이 끝나면 SseEmitter도 완료
                .doOnError(emitter::completeWithError) // 에러 발생 시 SseEmitter도 에러와 함께 완료
                .subscribe(chunk -> { // 각 데이터 조각(chunk)을 받을 때마다 처리
                    try {
                        // "data: " 접두사 제거 및 파싱
                        String cleanChunk = stripPrefix(chunk);
                        if (!cleanChunk.isEmpty() && !cleanChunk.equals("[DONE]")) {
                            String content = parseOpenRouterChunk(cleanChunk);
                            if (content != null && !content.isEmpty()) {
                                // SseEmitter를 통해 클라이언트로 데이터 전송
                                emitter.send(SseEmitter.event().data(content));
                            }
                        }
                    } catch (IOException e) {
                        log.error("SseEmitter send error", e);
                        emitter.completeWithError(e);
                    }
                });
    }

    private String stripPrefix(String rawEventData) {
        if (rawEventData.startsWith("data: ")) {
            return rawEventData.substring("data: ".length()).trim();
        }
        return rawEventData.trim();
    }

    private String parseOpenRouterChunk(String jsonChunk) {
        try {
            JsonNode rootNode = objectMapper.readTree(jsonChunk);
            JsonNode choicesNode = rootNode.path("choices");
            if (choicesNode.isArray() && !choicesNode.isEmpty()) {
                JsonNode firstChoice = choicesNode.get(0);
                JsonNode deltaNode = firstChoice.path("delta");
                JsonNode contentNode = deltaNode.path("content");
                if (contentNode.isTextual()) {
                    return contentNode.asText();
                }
            }
        } catch (Exception e) {
            log.error("OpenRouter 청크 파싱 오류. Chunk: '{}'", jsonChunk, e);
        }
        return "";
    }
}