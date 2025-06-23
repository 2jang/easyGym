package com.isix.easyGym.common;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;

@Controller
public class ImageController {

    @GetMapping("/images/**")
    public ResponseEntity<Resource> getImage(HttpServletRequest request) {
        try {
            String requestPath = request.getRequestURI().substring("/images/".length());

            // 정확한 경로로 먼저 시도
            Resource resource = new ClassPathResource("static/images/" + requestPath);

            if (!resource.exists()) {
                // 대소문자 구분 없이 찾기
                resource = findCaseInsensitiveImage(requestPath);
            }

            if (resource != null && resource.exists()) {
                String contentType = getContentType(resource.getFilename());

                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.parseMediaType(contentType));

                return ResponseEntity.ok().headers(headers).body(resource);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ResponseEntity.notFound().build();
    }

    private Resource findCaseInsensitiveImage(String requestPath) {
        try {
            int lastDotIndex = requestPath.lastIndexOf('.');
            if (lastDotIndex > 0) {
                String pathWithoutExt = requestPath.substring(0, lastDotIndex);
                String extension = requestPath.substring(lastDotIndex + 1);

                // 다양한 확장자 조합 시도
                String[] possibleExtensions = {
                        extension.toLowerCase(),  // .png
                        extension.toUpperCase(),  // .PNG
                        extension                 // 원본
                };

                for (String ext : possibleExtensions) {
                    String possiblePath = pathWithoutExt + "." + ext;
                    Resource resource = new ClassPathResource("static/images/" + possiblePath);
                    if (resource.exists()) {
                        return resource;
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    private String getContentType(String filename) {
        if (filename == null) return "application/octet-stream";

        String ext = filename.toLowerCase();
        if (ext.endsWith(".png")) return "image/png";
        else if (ext.endsWith(".jpg") || ext.endsWith(".jpeg")) return "image/jpeg";
        else if (ext.endsWith(".gif")) return "image/gif";
        else if (ext.endsWith(".svg")) return "image/svg+xml";
        else if (ext.endsWith(".webp")) return "image/webp";

        return "application/octet-stream";
    }
}