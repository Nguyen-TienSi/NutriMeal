package com.uth.nutriai.security;

import com.uth.nutriai.utils.SecurityUtils;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.AuditorAware;
import org.springframework.lang.NonNull;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Component;

import java.util.Objects;
import java.util.Optional;

@Slf4j
@Component
public class SpringSecurityAuditorAware implements AuditorAware<String> {
    
    private static final String SYSTEM_USER = "SYSTEM";

    @Override
    @NonNull
    public Optional<String> getCurrentAuditor() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        if (!isValidAuthentication(authentication)) {
            return Optional.of(SYSTEM_USER);
        }

        String accountId = SecurityUtils.extractAccountId();

        return Optional.of(Objects.requireNonNullElse(accountId, SYSTEM_USER));
    }

    private boolean isValidAuthentication(Authentication authentication) {
        return authentication != null
                && authentication.isAuthenticated()
                && !(authentication instanceof AnonymousAuthenticationToken);
    }
}
