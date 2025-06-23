package com.isix.easyGym.common;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import java.util.Arrays;
import java.util.List;

@Controller
@RequestMapping("/images")
public class ImageController {

    private static final List<String> IMAGE_EXTENSIONS = Arrays.asList(
        "png", "jpg", "jpeg", "gif", "svg", "webp", "bmp", "tiff", "ico"
    );

    private static final List<String> SEARCH_PATHS = Arrays.asList(
        "static/images/",
        "static/",
        "META-INF/resources/images/",
        "META-INF/resources/"
    );

    @GetMapping("/**")
    public ResponseEntity<Resource> getImage(HttpServletRequest request) {
        try {
            String requestPath = extractPath(request);
            
            // 1단계: 정확한 경로로 시도
            Resource resource = findExactResource(requestPath);
            if (resource != null && resource.exists()) {
                return createImageResponse(resource);
            }

            // 2단계: 대소문자 구분 없이 시도
            resource = findCaseInsensitiveResource(requestPath);
            if (resource != null && resource.exists()) {
                return createImageResponse(resource);
            }

            // 3단계: 확장자 변형 시도
            resource = findWithDifferentExtensions(requestPath);
            if (resource != null && resource.exists()) {
                return createImageResponse(resource);
            }

            return ResponseEntity.notFound().build();
            
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    @GetMapping("/{folder}/**")
    public ResponseEntity<Resource> getImageFromFolder(
            @PathVariable String folder,
            HttpServletRequest request) {
        return getImage(request);
    }

    private String extractPath(HttpServletRequest request) {
        String requestURI = request.getRequestURI();
        String contextPath = request.getContextPath();
        
        String path = requestURI;
        if (path.startsWith(contextPath)) {
            path = path.substring(contextPath.length());
        }
        if (path.startsWith("/images/")) {
            path = path.substring("/images/".length());
        } else if (path.startsWith("images/")) {
            path = path.substring("images/".length());
        }
        
        return path;
    }

    private Resource findExactResource(String requestPath) {
        for (String basePath : SEARCH_PATHS) {
            try {
                ClassPathResource resource = new ClassPathResource(basePath + requestPath);
                if (resource.exists()) {
                    return resource;
                }
            } catch (Exception e) {
                // 무시하고 계속
            }
        }
        return null;
    }

    private Resource findCaseInsensitiveResource(String requestPath) {
        String fileName = getFileName(requestPath);
        String directoryPath = getDirectoryPath(requestPath);
        
        if (fileName == null) {
            return null;
        }

        String nameWithoutExt = StringUtils.stripFilenameExtension(fileName);
        String extension = StringUtils.getFilenameExtension(fileName);

        if (extension == null) {
            return null;
        }

        String[] nameVariations = {
            nameWithoutExt,
            nameWithoutExt.toLowerCase(),
            nameWithoutExt.toUpperCase(),
            capitalize(nameWithoutExt)
        };

        String[] extensionVariations = {
            extension,
            extension.toLowerCase(),
            extension.toUpperCase()
        };

        for (String basePath : SEARCH_PATHS) {
            for (String nameVar : nameVariations) {
                for (String extVar : extensionVariations) {
                    try {
                        String possiblePath = basePath + directoryPath + nameVar + "." + extVar;
                        ClassPathResource resource = new ClassPathResource(possiblePath);
                        if (resource.exists()) {
                            return resource;
                        }
                    } catch (Exception e) {
                        // 무시하고 계속
                    }
                }
            }
        }

        return null;
    }

    private Resource findWithDifferentExtensions(String requestPath) {
        String fileName = getFileName(requestPath);
        String directoryPath = getDirectoryPath(requestPath);
        
        if (fileName == null) {
            return null;
        }

        String nameWithoutExt = StringUtils.stripFilenameExtension(fileName);

        for (String basePath : SEARCH_PATHS) {
            for (String ext : IMAGE_EXTENSIONS) {
                try {
                    String possiblePath = basePath + directoryPath + nameWithoutExt + "." + ext;
                    ClassPathResource resource = new ClassPathResource(possiblePath);
                    if (resource.exists()) {
                        return resource;
                    }
                } catch (Exception e) {
                    // 무시하고 계속
                }
            }
        }

        return null;
    }

    private ResponseEntity<Resource> createImageResponse(Resource resource) {
        try {
            String contentType = getContentType(resource.getFilename());
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.parseMediaType(contentType));
            headers.setCacheControl("public, max-age=3600"); // 1시간 캐시
            
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(resource);
                    
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private String getContentType(String filename) {
        if (filename == null) {
            return "application/octet-stream";
        }

        String ext = StringUtils.getFilenameExtension(filename);
        if (ext == null) {
            return "application/octet-stream";
        }

        ext = ext.toLowerCase();
        switch (ext) {
            case "png": return "image/png";
            case "jpg":
            case "jpeg": return "image/jpeg";
            case "gif": return "image/gif";
            case "svg": return "image/svg+xml";
            case "webp": return "image/webp";
            case "bmp": return "image/bmp";
            case "tiff":
            case "tif": return "image/tiff";
            case "ico": return "image/x-icon";
            default: return "application/octet-stream";
        }
    }

    private String getFileName(String path) {
        if (path == null || path.isEmpty()) {
            return null;
        }
        int lastSlash = path.lastIndexOf('/');
        return lastSlash >= 0 ? path.substring(lastSlash + 1) : path;
    }

    private String getDirectoryPath(String path) {
        if (path == null || path.isEmpty()) {
            return "";
        }
        int lastSlash = path.lastIndexOf('/');
        return lastSlash >= 0 ? path.substring(0, lastSlash + 1) : "";
    }

    private String capitalize(String str) {
        if (str == null || str.isEmpty()) {
            return str;
        }
        return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
    }
}
