package com.uth.nutriai.security;

import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class GoogleAuthenticationConverter extends AbstractOAuth2AuthenticationConverter {
    
    private final JwtDecoder jwtDecoder;
    
    @Override
    protected Authentication doConvert(String token) {
        Jwt jwt = jwtDecoder.decode(token);
        return new JwtAuthenticationToken(jwt, AuthorityUtils.createAuthorityList("ROLE_USER"));

    }
}
