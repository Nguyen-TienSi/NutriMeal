package com.uth.nutriai.security;

import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.AuthenticationConverter;
import org.springframework.stereotype.Component;

import java.util.Map;
import java.util.Objects;

@Component
@RequiredArgsConstructor
public class TokenAuthenticationConverter implements AuthenticationConverter {

    private final Map<AuthenticationProvider, AuthenticationConverter> converters;

    @Override
    public Authentication convert(HttpServletRequest request) {
        return converters.values().stream()
                .map(converter -> tryConvert(converter, request))
                .filter(Objects::nonNull)
                .findFirst()
                .orElse(null);
    }

    private Authentication tryConvert(AuthenticationConverter converter, HttpServletRequest request) {
        try {
            return converter.convert(request);
        } catch (Exception e) {
            return null;
        }
    }
}
