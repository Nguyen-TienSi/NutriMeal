package com.uth.nutriai.config;

import java.time.Instant;
import java.time.ZonedDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.concurrent.TimeUnit;

import com.mongodb.lang.NonNull;
import com.uth.nutriai.converter.DurationToLongWriteConverter;
import com.uth.nutriai.converter.LongToDurationReadConverter;
import com.uth.nutriai.converter.TimeOfDayReadConverter;
import com.uth.nutriai.converter.TimeOfDayWriteConverter;
import org.bson.UuidRepresentation;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.autoconfigure.mongo.MongoProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Lazy;
import org.springframework.context.annotation.Primary;
import org.springframework.core.convert.converter.Converter;
import org.springframework.dao.annotation.PersistenceExceptionTranslationPostProcessor;
import org.springframework.data.auditing.DateTimeProvider;
import org.springframework.data.convert.CustomConversions;
import org.springframework.data.mongodb.MongoDatabaseFactory;
import org.springframework.data.mongodb.MongoTransactionManager;
import org.springframework.data.mongodb.config.AbstractMongoClientConfiguration;
import org.springframework.data.mongodb.config.EnableMongoAuditing;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.SimpleMongoClientDatabaseFactory;
import org.springframework.data.mongodb.core.convert.DefaultDbRefResolver;
import org.springframework.data.mongodb.core.convert.DefaultMongoTypeMapper;
import org.springframework.data.mongodb.core.convert.MappingMongoConverter;
import org.springframework.data.mongodb.core.convert.MongoCustomConversions;
import org.springframework.data.mongodb.core.mapping.MongoMappingContext;
import org.springframework.data.mongodb.core.mapping.MongoSimpleTypes;
import org.springframework.data.mongodb.core.mapping.event.ValidatingMongoEventListener;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;

import com.mongodb.ConnectionString;
import com.mongodb.MongoClientSettings;
import com.mongodb.ReadPreference;
import com.mongodb.client.MongoClient;
import com.mongodb.client.MongoClients;
import com.uth.nutriai.repository.UuidIdentifiedRepositoryImpl;

import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

@Configuration
@EnableMongoRepositories(basePackages = "com.uth.nutriai.repository", repositoryBaseClass = UuidIdentifiedRepositoryImpl.class)
@EnableMongoAuditing(dateTimeProviderRef = "auditingDateTimeProvider", auditorAwareRef = "auditingProvider")
public class MongoConfig extends AbstractMongoClientConfiguration {

    @Bean(name = "mongoProperties")
    MongoProperties mongoProperties() {
        return new MongoProperties();
    }

    @Override
    @NonNull
    protected String getDatabaseName() {
        return mongoProperties().getDatabase();
    }

    @Bean(name = "mongoClient")
    MongoClient mongoClient(@Qualifier("mongoProperties") MongoProperties mongoProperties) {
        MongoClientSettings settings = MongoClientSettings.builder()
                .applyConnectionString(new ConnectionString(mongoProperties.getUri()))
                .uuidRepresentation(UuidRepresentation.STANDARD)
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
                .readPreference(ReadPreference.nearest())
                .build();

        return MongoClients.create(settings);
    }

    @Primary
    @Bean("mongoDbFactory")
    MongoDatabaseFactory mongoDbFactory(
            @Qualifier("mongoClient") MongoClient mongoClient,
            @Qualifier("mongoProperties") MongoProperties mongoProperties) {
        return new SimpleMongoClientDatabaseFactory(mongoClient, mongoProperties.getDatabase());
    }

    @Override
    @Bean(name = "mongoTemplate")
    @Lazy
    @NonNull
    public MongoTemplate mongoTemplate(
            @NonNull @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory,
            @NonNull @Qualifier("mappingMongoConverter") MappingMongoConverter mappingMongoConverter) {
        return new MongoTemplate(mongoDbFactory, mappingMongoConverter);
    }

    @Bean(name = "exceptionTranslation")
    static PersistenceExceptionTranslationPostProcessor exceptionTranslation() {
        return new PersistenceExceptionTranslationPostProcessor();
    }

    @Bean(name = "validatingMongoEventListener")
    ValidatingMongoEventListener validatingMongoEventListener(final LocalValidatorFactoryBean validator) {
        return new ValidatingMongoEventListener(validator);
    }

    @Primary
    @Bean("mongoMappingContext")
    MongoMappingContext mongoMappingContext() {
        MongoMappingContext context = new MongoMappingContext();
        context.setAutoIndexCreation(true);
        context.setSimpleTypeHolder(MongoSimpleTypes.HOLDER);
        context.afterPropertiesSet();
        context.afterPropertiesSet();
        return context;
    }

    @Primary
    @Bean(name = "transactionManager")
    MongoTransactionManager transactionManager(
            @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory) {
        return new MongoTransactionManager(mongoDbFactory);
    }

    @Override
    @Primary
    @Bean("mappingMongoConverter")
    @NonNull
    public MappingMongoConverter mappingMongoConverter(
            @NonNull @Qualifier("mongoDbFactory") MongoDatabaseFactory mongoDbFactory,
            @NonNull @Qualifier("mongoCustomConversions") MongoCustomConversions mongoCustomConversions,
            @NonNull @Qualifier("mongoMappingContext") MongoMappingContext mongoMappingContext) {
        DefaultDbRefResolver dbRefResolver = new DefaultDbRefResolver(mongoDbFactory);
        MappingMongoConverter converter = new MappingMongoConverter(dbRefResolver, mongoMappingContext) {
            @Override
            public void setCustomConversions(@NonNull CustomConversions conversions) {
                super.setCustomConversions(conversions);
                conversions.registerConvertersIn(conversionService);
            }
        };
        converter.setCustomConversions(mongoCustomConversions);
        converter.setCodecRegistryProvider(mongoDbFactory);
        converter.afterPropertiesSet();
        converter.setTypeMapper(new DefaultMongoTypeMapper(null));
        return converter;
    }

    @Bean(name = "auditingDateTimeProvider")
    DateTimeProvider dateTimeProvider() {
        ZonedDateTime zonedDateTime = ZonedDateTime.now(); // Current time zone system
        Instant instant = zonedDateTime.toInstant(); // Convert to (UTC)

        return () -> Optional.of(instant);
    }

    @Bean(name = "mongoCustomConversions")
    MongoCustomConversions mongoCustomConversions() {
        List<Converter<?, ?>> converters = new ArrayList<>();
        converters.add(new DurationToLongWriteConverter());
        converters.add(new LongToDurationReadConverter());
        converters.add(new TimeOfDayWriteConverter());
        converters.add(new TimeOfDayReadConverter());
        return new MongoCustomConversions(converters);
    }
}
