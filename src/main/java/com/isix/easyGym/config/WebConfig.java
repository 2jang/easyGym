package com.isix.easyGym.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.core.Ordered;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;

@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // 이미지 리소스 핸들러
        registry.addResourceHandler("/images/**")
                .addResourceLocations(
                    "classpath:/static/images/",
                    "classpath:/static/",
                    "classpath:/META-INF/resources/images/"
                )
                .setCachePeriod(3600) // 1시간 캐시
                .resourceChain(true)
                .addResolver(new CaseInsensitiveResourceResolver());

        // CSS 리소스 핸들러
        registry.addResourceHandler("/css/**")
                .addResourceLocations(
                    "classpath:/static/css/",
                    "classpath:/static/"
                )
                .setCachePeriod(3600);

        // JavaScript 리소스 핸들러
        registry.addResourceHandler("/js/**")
                .addResourceLocations(
                    "classpath:/static/js/",
                    "classpath:/static/"
                )
                .setCachePeriod(3600);

        // 정적 리소스 핸들러
        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/")
                .setCachePeriod(3600);

        // 루트 정적 리소스 핸들러
        registry.addResourceHandler("/**")
                .addResourceLocations(
                    "classpath:/static/",
                    "classpath:/public/",
                    "classpath:/resources/",
                    "classpath:/META-INF/resources/"
                )
                .setCachePeriod(3600);
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("forward:/main.do");
        registry.setOrder(Ordered.HIGHEST_PRECEDENCE);
    }
}
