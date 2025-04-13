// package com.uth.nutriai.security;

// import org.springframework.beans.factory.annotation.Value;
// import org.springframework.context.annotation.Bean;
// import org.springframework.context.annotation.Configuration;
// import org.springframework.core.Ordered;
// import org.springframework.core.annotation.Order;
// import org.springframework.security.config.Customizer;
// import
// org.springframework.security.config.annotation.web.builders.HttpSecurity;
// import
// org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
// import org.springframework.security.oauth2.jwt.JwtDecoder;
// import org.springframework.security.oauth2.jwt.JwtDecoders;
// import
// org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
// import org.springframework.security.web.SecurityFilterChain;

// @Configuration
// @EnableWebSecurity
// public class SecurityConfig {

// private final String[] PUBLIC_ENDPOINTS = {};

// @Bean
// @Order(Ordered.HIGHEST_PRECEDENCE)
// SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
// http
// .authorizeHttpRequests((authz) -> authz
// .requestMatchers(PUBLIC_ENDPOINTS).permitAll()
// .anyRequest().authenticated())
// .oauth2ResourceServer(oauth2 -> oauth2.jwt(Customizer.withDefaults()));

// return http.formLogin(Customizer.withDefaults()).build();
// }

// @Bean
// JwtDecoder jwtDecoder(
// @Value("${spring.security.oauth2.resource server.jwt.issuer-uri}") String
// issuerUri) {
// return JwtDecoders.fromIssuerLocation(issuerUri);
// }
// }
