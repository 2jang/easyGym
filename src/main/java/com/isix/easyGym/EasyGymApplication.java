package com.isix.easyGym;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableAsync;

@EnableAsync
@SpringBootApplication
public class EasyGymApplication {

	public static void main(String[] args) {
		SpringApplication.run(EasyGymApplication.class, args);
	}

}
