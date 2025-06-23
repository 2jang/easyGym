package com.isix.easyGym.chatbot.controller;

import com.isix.easyGym.chatbot.service.ChatbotService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

@RestController
public class ChatbotController {

    private static final Logger log = LoggerFactory.getLogger(ChatbotController.class);
    private final ChatbotService chatbotService;

    @Autowired
    public ChatbotController(ChatbotService chatbotService) {
        this.chatbotService = chatbotService;
    }

    @GetMapping(value = "/chatbot/stream-chat", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter streamChat(@RequestParam String question) {
        // 타임아웃을 넉넉하게 1분으로 설정
        SseEmitter emitter = new SseEmitter(60_000L);

        // 비동기 작업이 완료되거나 타임아웃, 에러 발생 시 처리
        emitter.onCompletion(() -> log.info("SseEmitter is completed for question: {}", question));
        emitter.onTimeout(() -> {
            log.warn("SseEmitter timed out for question: {}", question);
            emitter.complete();
        });
        emitter.onError(e -> log.error("SseEmitter error for question: " + question, e));

        // 비동기적으로 서비스를 호출하여 LLM 응답 스트리밍 시작
        chatbotService.streamChatResponse(question, emitter);

        return emitter;
    }
}