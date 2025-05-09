package com.uth.nutriai.security;

import com.uth.nutriai.utils.SecurityUtils;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationServiceException;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationConverter;

import java.util.Optional;

@RequiredArgsConstructor
public abstract class AbstractOAuth2AuthenticationConverter implements AuthenticationConverter {
    
    @Override
    public final Authentication convert(HttpServletRequest request) {
        try {
            Optional<String> token = SecurityUtils.extractTokenFromRequest(request);
            if (token.isEmpty() || token.get().isEmpty()) {
                throw new BadCredentialsException("Missing authorization token");
            }
            
            return doConvert(token.get());
        } catch (AuthenticationException e) {
            throw e;
        } catch (Exception e) {
            throw new AuthenticationServiceException("Authentication failed", e);
        }
    }
    
    protected abstract Authentication doConvert(String token);
}
