package com.uth.nutriai.config;

import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.scheduling.annotation.EnableAsync;

@Configuration
@EnableAsync
@EnableMongoAuditing
public class MongoConfig {
}
