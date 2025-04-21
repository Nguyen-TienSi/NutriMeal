package com.uth.nutriai.security;

import java.util.Optional;
import java.util.UUID;

import org.springframework.data.domain.AuditorAware;
import org.springframework.lang.NonNull;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;

import com.uth.nutriai.model.domain.User;

@Component("auditingProvider")
public class SpringSecurityAuditorAware implements AuditorAware<UUID> {

    @Override
    @NonNull
    public Optional<UUID> getCurrentAuditor() {
        return Optional.ofNullable(SecurityContextHolder.getContext())
                .map(SecurityContext::getAuthentication)
                .filter(Authentication::isAuthenticated)
                .map(Authentication::getPrincipal)
                .filter(User.class::isInstance)
                .map(User.class::cast)
                .map(User::getId);
    }

}
