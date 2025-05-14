package com.uth.nutriai;

import com.uth.nutriai.config.DotEnvConfig;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.data.mongo.MongoDataAutoConfiguration;
import org.springframework.boot.autoconfigure.mongo.MongoAutoConfiguration;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;

@SpringBootApplication(exclude = {
		SecurityAutoConfiguration.class,
		MongoAutoConfiguration.class,
		MongoDataAutoConfiguration.class
})
public class NutriAiApplication {

	public static void main(String[] args) {

//		DotEnvConfig.load();

		SpringApplication.run(NutriAiApplication.class, args);
	}

}
