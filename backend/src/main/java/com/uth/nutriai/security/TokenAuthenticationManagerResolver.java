package com.uth.nutriai.security;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationManagerResolver;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class TokenAuthenticationManagerResolver implements AuthenticationManagerResolver<HttpServletRequest> {

    private final TokenAuthenticationConverter tokenAuthenticationConverter;

    @Override
    public AuthenticationManager resolve(HttpServletRequest context) {

        try {
            Authentication authentication = tokenAuthenticationConverter.convert(context);
            if (authentication != null) {
                authentication.setAuthenticated(true);
                return __ -> authentication;
            }
            throw new AuthenticationException("Authentication failed") {
            };
        } catch (Exception e) {
            log.error("Error converting token: ", e);
            throw new AuthenticationException("Authentication failed", e) {
            };
        }
    }
}
