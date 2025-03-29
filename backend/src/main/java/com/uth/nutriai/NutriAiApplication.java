package com.uth.nutriai;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = { SecurityAutoConfiguration.class })
public class NutriAiApplication {

	public static void main(String[] args) {
		SpringApplication.run(NutriAiApplication.class, args);
	}

}
