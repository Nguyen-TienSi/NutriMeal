package com.uth.nutriai.config;

import java.util.Optional;
import java.util.UUID;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.mongodb.core.mapping.event.BeforeConvertCallback;

import com.uth.nutriai.model.UuidIdentifiedEntity;

@Configuration
public class EntityCallbackConfig {

    @Bean
    BeforeConvertCallback<UuidIdentifiedEntity> beforeSaveCallback() {

        return (entity, collection) -> {
            Optional.ofNullable(entity.getId())
                    .orElseGet(() -> {
                        entity.setId(UUID.randomUUID());
                        return entity.getId();
                    });
            return entity;
        };
    }

}
