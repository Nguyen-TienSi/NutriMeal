package com.uth.nutriai.config;

import java.time.OffsetDateTime;
import java.util.Arrays;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.mongo.MongoClientSettingsBuilderCustomizer;
import org.springframework.boot.autoconfigure.mongo.MongoProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Primary;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.auditing.DateTimeProvider;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.mongodb.MongoDatabaseFactory;
import org.springframework.data.mongodb.MongoTransactionManager;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.core.convert.DefaultDbRefResolver;
import org.springframework.data.mongodb.core.convert.DefaultMongoTypeMapper;
import org.springframework.data.mongodb.core.convert.MappingMongoConverter;
import org.springframework.data.mongodb.core.convert.MongoCustomConversions;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.data.mongodb.core.mapping.event.ValidatingMongoEventListener;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.ReadPreference;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;

import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

@Configuration
@EnableMongoRepositories(basePackages = "com.uth.nutriai.repository")
@EnableMongoAuditing(dateTimeProviderRef = "auditingDateTimeProvider", auditorAwareRef = "auditorProvider")
public class MongoConfig {
    @Bean
    MongoProperties mongoProperties() {
        return new MongoProperties();
    }

    @Bean
    MongoClient mongoClient() {
        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(new ConnectionString(mongoProperties().getUri()))
                .applyToConnectionPoolSettings(builder -> builder
                        .maxConnectionIdleTime(60, TimeUnit.SECONDS)
                        .minSize(50)
                        .maxSize(100)
                        .maxWaitTime(2000, TimeUnit.MILLISECONDS))
                .applyToClusterSettings(builder -> builder
                        .serverSelectionTimeout(10, TimeUnit.SECONDS))
                .applyToSocketSettings(builder -> builder
                        .connectTimeout(10, TimeUnit.SECONDS)
                        .readTimeout(10, TimeUnit.SECONDS))
                .build();

        return MongoClients.create(settings);
    }

    @Primary
    @Bean("mongoDbFactory")
    MongoDatabaseFactory mongoDbFactory() {
        return new SimpleMongoClientDatabaseFactory(mongoClient(), mongoProperties().getDatabase());
    }

    @Bean
    @Lazy
    MongoTemplate mongoTemplate(
            @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory,
            @Qualifier("mappingMongoConverter") MappingMongoConverter mappingMongoConverter) {
        return new MongoTemplate(mongoDbFactory, mappingMongoConverter);
    }

    @Bean
    PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
        return new PersistenceExceptionTranslationPostProcessor();
    }

    @Bean
    ValidatingMongoEventListener validatingMongoEventListener(final LocalValidatorFactoryBean validator) {
        return new ValidatingMongoEventListener(validator);
    }

    @Primary
    @Bean("mongoMappingContext")
    MongoMappingContext mongoMappingContext() throws ClassNotFoundException {
        MongoMappingContext context = new MongoMappingContext();
        context.setAutoIndexCreation(true);
        return context;
    }

    @Primary
    @Bean
    MongoTransactionManager transactionManager(
            @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory) {
        return new MongoTransactionManager(mongoDbFactory);
    }

    @Primary
    @Bean("mappingMongoConverter")
    MappingMongoConverter mappingMongoConverter(
            @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory,
            @Qualifier("mongoMappingContext") MongoMappingContext mongoMappingContext) {
        DefaultDbRefResolver dbRefResolver = new DefaultDbRefResolver(mongoDbFactory);
        MappingMongoConverter converter = new MappingMongoConverter(dbRefResolver, mongoMappingContext);
        converter.setTypeMapper(new DefaultMongoTypeMapper(null));
        return converter;
    }

    @Bean(name = "auditingDateTimeProvider")
    DateTimeProvider dateTimeProvider() {
        return () -> Optional.of(OffsetDateTime.now());
    }

    @Bean(name = "auditorProvider")
    AuditorAware<String> auditorProvider() {
        return () -> Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .filter(Authentication::isAuthenticated)
                .map(Authentication::getName).or(() -> Optional.of("system"));
    }

    @Bean
    MongoCustomConversions mongoCustomConversions() {
        return new MongoCustomConversions(Arrays.asList(
                new MongoOffsetDateTimeWriter(),
                new MongoOffsetDateTimeReader()));
    }

    @Bean
    MongoClientSettingsBuilderCustomizer monoClientCustomizer() {
        return builder -> builder.readPreference(ReadPreference.nearest());
    }
}
