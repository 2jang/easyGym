package com.isix.easyGym.common;

import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Random;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Component
public class RandomImageService {

    private final ResourceLoader resourceLoader;
    private List<String> cachedImagePaths;
    private final Random random = new Random();

    private static final List<String> IMAGE_EXTENSIONS = List.of(".png", ".jpg", ".jpeg", ".gif", ".webp");
    private static final String DEFAULT_IMAGE_PATH = "";

    @Autowired
    public RandomImageService(ResourceLoader resourceLoader) {
        this.resourceLoader = resourceLoader;
    }

    @PostConstruct
    public void initialize() {
        List<String> targetFolders = List.of("boxing", "pilates", "health");
        List<String> allImagePaths = new ArrayList<>();

        try {
            Path staticBasePath = Paths.get(resourceLoader.getResource("classpath:static/").getURI());

            for (String folderName : targetFolders) {
                try {
                    String folderResourcePath = "classpath:static/images/detail/" + folderName + "/";
                    Resource resource = resourceLoader.getResource(folderResourcePath);

                    if (!resource.exists()) {
                        System.out.println("RandomImageService: '" + folderName + "' 폴더를 찾을 수 없어 건너뜁니다.");
                        continue;
                    }

                    Path folderPath = Paths.get(resource.getURI());
                    try (Stream<Path> paths = Files.walk(folderPath)) {
                        List<String> imagePathsInFolder = paths
                                .filter(Files::isRegularFile)
                                .filter(path -> {
                                    String fileName = path.getFileName().toString().toLowerCase();
                                    return IMAGE_EXTENSIONS.stream().anyMatch(fileName::endsWith);
                                })
                                .map(path -> {
                                    String webPath = staticBasePath.relativize(path).toString();
                                    return "/" + webPath.replace('\\', '/');
                                })
                                .collect(Collectors.toList());

                        allImagePaths.addAll(imagePathsInFolder);
                    }
                } catch (IOException e) {
                    System.err.println("RandomImageService: '" + folderName + "' 폴더 스캔 중 오류 발생 - " + e.getMessage());
                }
            }

            this.cachedImagePaths = allImagePaths;

            if (!cachedImagePaths.isEmpty()) {
                System.out.println("RandomImageService: " + cachedImagePaths.size() + "개의 이미지를 " + targetFolders + " 폴더 내에서 캐싱했습니다.");
            } else {
                System.err.println("RandomImageService: 대상 폴더(" + String.join(", ", targetFolders) + ")에서 이미지를 찾을 수 없습니다.");
            }

        } catch (IOException e) {
            System.err.println("RandomImageService: 'static' 기본 경로를 가져오는 중 심각한 오류 발생: " + e.getMessage());
            this.cachedImagePaths = Collections.emptyList();
        }
    }

    public String getRandomImagePath() {
        if (cachedImagePaths == null || cachedImagePaths.isEmpty()) {
            return DEFAULT_IMAGE_PATH;
        }
        int index = random.nextInt(cachedImagePaths.size());
        return cachedImagePaths.get(index);
    }

    /**
     * 캐싱된 모든 이미지 경로의 리스트를 반환합니다.
     * @return 캐싱된 이미지 경로 List
     */
    public List<String> getAllCachedImagePaths() {
        return this.cachedImagePaths != null ? this.cachedImagePaths : Collections.emptyList();
    }
}