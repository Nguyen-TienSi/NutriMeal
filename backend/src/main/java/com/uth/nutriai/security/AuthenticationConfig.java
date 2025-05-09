package com.uth.nutriai.security;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.jwt.JwtDecoders;
import org.springframework.security.oauth2.server.resource.introspection.OpaqueTokenIntrospector;
import org.springframework.security.web.authentication.AuthenticationConverter;

import java.util.Map;

@Configuration
public class AuthenticationConfig {

    @Bean
    JwtDecoder jwtDecoder(
            @Value("${spring.security.oauth2.resource-server.jwt.issuer-uri}") String issuerUri
    ) {
        return JwtDecoders.fromOidcIssuerLocation(issuerUri);
    }

    @Bean
    public OpaqueTokenIntrospector opaqueTokenIntrospector(
            FacebookOpaqueTokenIntrospector facebookOpaqueTokenIntrospector
    ) {
        return facebookOpaqueTokenIntrospector;
    }

    @Bean
    public Map<AuthenticationProvider, AuthenticationConverter> authenticationConverters(
            GoogleAuthenticationConverter googleAuthenticationConverter,
            FacebookAuthenticationConverter facebookAuthenticationConverter
    ) {
        return Map.of(
                AuthenticationProvider.GOOGLE, googleAuthenticationConverter,
                AuthenticationProvider.FACEBOOK, facebookAuthenticationConverter
        );
    }
}
