package com.uth.nutriai.config;

import com.uth.nutriai.security.SpringSecurityAuditorAware;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.auditing.DateTimeProvider;
import org.springframework.data.domain.AuditorAware;
import org.springframework.data.mongodb.config.EnableMongoAuditing;

import java.time.ZonedDateTime;
import java.util.Optional;

@Configuration
@EnableMongoAuditing(
        dateTimeProviderRef = "dateTimeProvider",
        auditorAwareRef = "auditorProvider"
)
public class AuditingConfig {

    @Bean
    public DateTimeProvider dateTimeProvider() {
        return () -> Optional.of(ZonedDateTime.now().toInstant());
    }

    @Bean
    public AuditorAware<String> auditorProvider() {
        return new SpringSecurityAuditorAware();
    }
}
