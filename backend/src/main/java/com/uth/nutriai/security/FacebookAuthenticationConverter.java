package com.uth.nutriai.security;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;
import org.springframework.security.oauth2.server.resource.introspection.OpaqueTokenIntrospector;
import org.springframework.stereotype.Component;

@Slf4j
@Component
@RequiredArgsConstructor
public class FacebookAuthenticationConverter extends AbstractOAuth2AuthenticationConverter {

    private final OpaqueTokenIntrospector opaqueTokenIntrospector;

    @Override
    protected Authentication doConvert(String token) {

        try {

            OAuth2AuthenticatedPrincipal principal = opaqueTokenIntrospector.introspect(token);

            OAuth2AccessToken accessToken = new OAuth2AccessToken(
                    OAuth2AccessToken.TokenType.BEARER,
                    token,
                    null,
                    null
            );

            return new BearerTokenAuthentication(principal, accessToken, principal.getAuthorities());
        } catch (Exception e) {
            log.error("Error converting Facebook token: ", e);
            return null;
        }

    }
}
