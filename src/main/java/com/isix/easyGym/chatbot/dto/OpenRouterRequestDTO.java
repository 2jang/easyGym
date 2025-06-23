package com.isix.easyGym.chatbot.dto;

import java.util.List;

public class OpenRouterRequestDTO {
    private String model;
    private List<Message> messages;
    private boolean stream;

    public OpenRouterRequestDTO(String model, List<Message> messages, boolean stream) {
        this.model = model;
        this.messages = messages;
        this.stream = stream;
    }

    // Getters
    public String getModel() { return model; }
    public List<Message> getMessages() { return messages; }
    public boolean isStream() { return stream; }

    public static class Message {
        private String role;
        private String content;

        public Message(String role, String content) {
            this.role = role;
            this.content = content;
        }

        // Getters
        public String getRole() { return role; }
        public String getContent() { return content; }
    }
}