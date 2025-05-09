package com.uth.nutriai.utils;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;

import java.util.Optional;

@Slf4j
public class SecurityUtils {

    public static Optional<String> extractTokenFromRequest(HttpServletRequest request) {

        String AUTHORIZATION_HEADER = "Authorization";
        String BEARER_PREFIX = "Bearer ";

        return Optional.ofNullable(request.getHeader(AUTHORIZATION_HEADER))
                .filter(header -> header.startsWith(BEARER_PREFIX))
                .map(header -> header.replace(BEARER_PREFIX, ""));
    }

    public static String extractToken() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return extractToken(authentication);
    }

    public static String extractToken(Authentication authentication) {
        if (authentication == null) {
            return null;
        }

        try {
            // Handle JWT authentication
            if (authentication.getPrincipal() instanceof Jwt jwt) {
                return jwt.getTokenValue();
            }

            // Handle Bearer token authentication
            if (authentication instanceof BearerTokenAuthentication bearerAuth) {
                return ((OAuth2AccessToken) bearerAuth.getCredentials()).getTokenValue();
            }

            // Handle OAuth2 authentication
            if (authentication.getPrincipal() instanceof OAuth2AuthenticatedPrincipal principal) {
                return principal.getAttribute("access_token");
            }

            log.warn("Unsupported authentication type: {}", authentication.getClass().getName());
            return null;

        } catch (Exception e) {
            log.error("Error extracting token from authentication", e);
            return null;
        }
    }

    public static String extractAccountId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        return extractAccountId(authentication);
    }

    public static String extractAccountId(Authentication authentication) {
        if (authentication == null) {
            return null;
        }

        try {
            if (authentication.getPrincipal() instanceof Jwt jwt) {
                return jwt.getSubject();
            }

            if (authentication.getPrincipal() instanceof OAuth2AuthenticatedPrincipal principal) {
                return principal.getName();
            }

            return null;
        } catch (Exception e) {
            log.error("Error extracting user ID from authentication", e);
            return null;
        }
    }

}
