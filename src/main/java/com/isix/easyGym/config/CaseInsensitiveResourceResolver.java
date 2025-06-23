package com.isix.easyGym.config;

import org.springframework.core.io.ClassPathResource;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.web.servlet.resource.AbstractResourceResolver;
import org.springframework.web.servlet.resource.ResourceResolverChain;
import org.springframework.util.StringUtils;

import jakarta.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.stream.Stream;

public class CaseInsensitiveResourceResolver extends AbstractResourceResolver {

    @Override
    protected Resource resolveResourceInternal(HttpServletRequest request, String requestPath,
                                             List<? extends Resource> locations, ResourceResolverChain chain) {
        
        // 먼저 정확한 경로로 찾기
        Resource resource = chain.resolveResource(request, requestPath, locations);
        if (resource != null && resource.exists()) {
            return resource;
        }

        // 대소문자 구분 없이 찾기
        for (Resource location : locations) {
            try {
                resource = findCaseInsensitiveResource(location, requestPath);
                if (resource != null && resource.exists()) {
                    return resource;
                }
            } catch (Exception e) {
                // 로그 없이 무시하고 계속
            }
        }

        return null;
    }

    @Override
    protected String resolveUrlPathInternal(String resourceUrlPath, List<? extends Resource> locations,
                                          ResourceResolverChain chain) {
        return chain.resolveUrlPath(resourceUrlPath, locations);
    }

    private Resource findCaseInsensitiveResource(Resource location, String requestPath) throws IOException {
        if (location instanceof ClassPathResource) {
            return findInClassPath((ClassPathResource) location, requestPath);
        } else if (location instanceof FileSystemResource) {
            return findInFileSystem((FileSystemResource) location, requestPath);
        } else if (location instanceof UrlResource) {
            return findInUrl((UrlResource) location, requestPath);
        }
        
        return null;
    }

    private Resource findInClassPath(ClassPathResource location, String requestPath) {
        try {
            String basePath = location.getPath();
            String fullPath = basePath + requestPath;
            
            // 정확한 경로 시도
            ClassPathResource exactResource = new ClassPathResource(fullPath);
            if (exactResource.exists()) {
                return exactResource;
            }

            // 파일명과 확장자 분리
            String[] pathParts = requestPath.split("/");
            String fileName = pathParts[pathParts.length - 1];
            
            if (!fileName.contains(".")) {
                return null;
            }

            String nameWithoutExt = StringUtils.stripFilenameExtension(fileName);
            String extension = StringUtils.getFilenameExtension(fileName);
            
            if (extension == null) {
                return null;
            }

            // 확장자 조합 시도
            String[] possibleExtensions = {
                extension.toLowerCase(),
                extension.toUpperCase(),
                extension,
                "png", "jpg", "jpeg", "gif", "svg", "webp", "bmp", "tiff", "ico"
            };

            String directoryPath = requestPath.substring(0, requestPath.lastIndexOf('/') + 1);
            
            for (String ext : possibleExtensions) {
                try {
                    String possiblePath = basePath + directoryPath + nameWithoutExt + "." + ext;
                    ClassPathResource possibleResource = new ClassPathResource(possiblePath);
                    if (possibleResource.exists()) {
                        return possibleResource;
                    }
                    
                    // 대소문자 조합 시도
                    String possiblePathUpper = basePath + directoryPath + nameWithoutExt.toUpperCase() + "." + ext;
                    ClassPathResource possibleResourceUpper = new ClassPathResource(possiblePathUpper);
                    if (possibleResourceUpper.exists()) {
                        return possibleResourceUpper;
                    }
                    
                    String possiblePathLower = basePath + directoryPath + nameWithoutExt.toLowerCase() + "." + ext;
                    ClassPathResource possibleResourceLower = new ClassPathResource(possiblePathLower);
                    if (possibleResourceLower.exists()) {
                        return possibleResourceLower;
                    }
                } catch (Exception e) {
                    // 무시하고 계속
                }
            }
            
        } catch (Exception e) {
            // 무시하고 계속
        }
        
        return null;
    }

    private Resource findInFileSystem(FileSystemResource location, String requestPath) {
        try {
            File baseDir = location.getFile();
            if (!baseDir.isDirectory()) {
                return null;
            }

            Path basePath = baseDir.toPath();
            Path targetPath = basePath.resolve(requestPath.replace("/", File.separator));
            
            // 정확한 경로 시도
            if (Files.exists(targetPath)) {
                return new FileSystemResource(targetPath.toFile());
            }

            // 대소문자 구분 없이 찾기
            Path parentDir = targetPath.getParent();
            if (parentDir == null || !Files.exists(parentDir)) {
                return null;
            }

            String targetFileName = targetPath.getFileName().toString();
            String nameWithoutExt = StringUtils.stripFilenameExtension(targetFileName);
            String extension = StringUtils.getFilenameExtension(targetFileName);

            if (extension == null) {
                return null;
            }

            try (Stream<Path> files = Files.list(parentDir)) {
                return files
                    .filter(Files::isRegularFile)
                    .filter(path -> {
                        String fileName = path.getFileName().toString();
                        String fileNameWithoutExt = StringUtils.stripFilenameExtension(fileName);
                        String fileExt = StringUtils.getFilenameExtension(fileName);
                        
                        return fileExt != null &&
                               nameWithoutExt.equalsIgnoreCase(fileNameWithoutExt) &&
                               (extension.equalsIgnoreCase(fileExt) || 
                                isImageExtension(fileExt));
                    })
                    .findFirst()
                    .map(path -> new FileSystemResource(path.toFile()))
                    .orElse(null);
            }
            
        } catch (Exception e) {
            // 무시하고 계속
        }
        
        return null;
    }

    private Resource findInUrl(UrlResource location, String requestPath) {
        try {
            String baseUrl = location.getURL().toString();
            if (!baseUrl.endsWith("/")) {
                baseUrl += "/";
            }
            
            String fullUrl = baseUrl + requestPath;
            UrlResource urlResource = new UrlResource(fullUrl);
            
            if (urlResource.exists()) {
                return urlResource;
            }
            
            // URL 기반에서는 대소문자 변형 시도가 제한적
            String fileName = requestPath.substring(requestPath.lastIndexOf('/') + 1);
            String nameWithoutExt = StringUtils.stripFilenameExtension(fileName);
            String extension = StringUtils.getFilenameExtension(fileName);
            
            if (extension != null) {
                String[] possibleExtensions = {
                    extension.toLowerCase(),
                    extension.toUpperCase()
                };
                
                String directoryPath = requestPath.substring(0, requestPath.lastIndexOf('/') + 1);
                
                for (String ext : possibleExtensions) {
                    try {
                        String possibleUrl = baseUrl + directoryPath + nameWithoutExt + "." + ext;
                        UrlResource possibleResource = new UrlResource(possibleUrl);
                        if (possibleResource.exists()) {
                            return possibleResource;
                        }
                    } catch (MalformedURLException e) {
                        // 무시
                    }
                }
            }
            
        } catch (Exception e) {
            // 무시하고 계속
        }
        
        return null;
    }

    private boolean isImageExtension(String extension) {
        if (extension == null) {
            return false;
        }
        
        String ext = extension.toLowerCase();
        return ext.equals("png") || ext.equals("jpg") || ext.equals("jpeg") || 
               ext.equals("gif") || ext.equals("svg") || ext.equals("webp") ||
               ext.equals("bmp") || ext.equals("tiff") || ext.equals("ico");
    }
}
