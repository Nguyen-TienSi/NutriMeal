package com.uth.nutriai.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoders;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final String[] SWAGGER_ENDPOINTS = {
            "/v3/api-docs/**",
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/swagger-docs",
            "/openapi.yaml",
            "/api-docs"
    };

    private final String[] WHITELIST_ENDPOINTS = {};

    @Bean
//    @Order(Ordered.HIGHEST_PRECEDENCE)
    SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
//                .securityMatcher()
                .authorizeHttpRequests((auth) -> auth
                        .requestMatchers(SWAGGER_ENDPOINTS).permitAll()
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers(WHITELIST_ENDPOINTS).permitAll()
                        .anyRequest().authenticated())
                .cors(Customizer.withDefaults())
                .csrf(csrfConfigurer -> csrfConfigurer
                        .ignoringRequestMatchers(SWAGGER_ENDPOINTS)
                        .ignoringRequestMatchers("/api/auth/**")
                        .csrfTokenRepository(new HttpSessionCsrfTokenRepository())
                )
                .formLogin(AbstractHttpConfigurer::disable)
                .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()))
                .sessionManagement(sessionManager -> sessionManager.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .oauth2Login(Customizer.withDefaults());

        return http
                .build();
    }

    @Bean
    JwtDecoder jwtDecoder(
            @Value("${spring.security.oauth2.resource-server.jwt.issuer-uri}") String issuerUri
    ) {
        return JwtDecoders.fromOidcIssuerLocation(issuerUri);
    }
}
