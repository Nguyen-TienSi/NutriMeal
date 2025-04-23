package com.uth.nutriai.config;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.databind.SerializationFeature;
import org.springframework.boot.autoconfigure.jackson.Jackson2ObjectMapperBuilderCustomizer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class JacksonConfig {

    @Bean
    Jackson2ObjectMapperBuilderCustomizer jackson2ObjectMapperBuilderCustomizer() {
        return builder -> {
          builder.serializationInclusion(JsonInclude.Include.NON_NULL);
          builder.failOnUnknownProperties(false);
          builder.featuresToEnable(SerializationFeature.WRITE_ENUMS_USING_TO_STRING);
        };
    }
}
