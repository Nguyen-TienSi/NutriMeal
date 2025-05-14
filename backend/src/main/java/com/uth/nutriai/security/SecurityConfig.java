package com.uth.nutriai.security;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManagerResolver;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.csrf.HttpSessionCsrfTokenRepository;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

@RequiredArgsConstructor
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    private final String[] SWAGGER_ENDPOINTS = {
            "/swagger-ui/**",
            "/swagger-ui.html",
            "/swagger-resources/**",
            "/swagger-resources",
            "/v3/api-docs/**",
            "/v3/api-docs",
            "/webjars/**",
            "/openapi.yaml"
    };
    private final String[] WHITELIST_ENDPOINTS = {
            "/api/auth/**",
            "/api/health",
            "/api/recipes/**",
            "/api/health-tracking/*",
            "/api/meal-logs/*",
            "greeting/**"
    };

    @Bean
    SecurityFilterChain filterChain(
            HttpSecurity http,
            AuthenticationManagerResolver<HttpServletRequest> resolver
    ) throws Exception {
        return http
                .authorizeHttpRequests((auth) -> auth
                        .requestMatchers(SWAGGER_ENDPOINTS).permitAll()
                        .requestMatchers(WHITELIST_ENDPOINTS).permitAll()
                        .anyRequest().authenticated()
                )
                .cors(corsConfigurer -> corsConfigurer
                        .configurationSource(corsConfigurationSource()))
                .csrf(csrfConfigurer -> csrfConfigurer
                        .ignoringRequestMatchers(SWAGGER_ENDPOINTS)
                        .ignoringRequestMatchers(WHITELIST_ENDPOINTS)
                        .csrfTokenRepository(new HttpSessionCsrfTokenRepository())
                )
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(AbstractHttpConfigurer::disable)
                .oauth2ResourceServer(oauth2 -> oauth2
                        .authenticationManagerResolver(resolver)
                )
                .sessionManagement(sessionManager -> sessionManager
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .build();
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOriginPatterns(Collections.singletonList("*"));
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS", "HEAD"));
        configuration.setAllowedHeaders(List.of("*"));
        configuration.setExposedHeaders(List.of("*"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}