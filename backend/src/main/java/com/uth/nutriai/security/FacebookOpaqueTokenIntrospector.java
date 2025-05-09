package com.uth.nutriai.security;

import com.uth.nutriai.utils.UriUtils;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.server.resource.introspection.OAuth2IntrospectionException;
import org.springframework.security.oauth2.server.resource.introspection.OpaqueTokenIntrospector;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.oauth2.core.DefaultOAuth2AuthenticatedPrincipal;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Component
public class FacebookOpaqueTokenIntrospector implements OpaqueTokenIntrospector {
    
    private final String introspectionUri;
    private final RestTemplate restTemplate;
    
    public FacebookOpaqueTokenIntrospector(
            @Value("${spring.security.oauth2.resource-server.opaque-token.introspection-uri}") String introspectionUri
    ) {
        this.introspectionUri = introspectionUri;
        this.restTemplate = new RestTemplate();
    }
    
    @Override
    public OAuth2AuthenticatedPrincipal introspect(String token) {
        String uri = UriUtils.buildFacebookGraphApiUrl(introspectionUri, token);
        
        try {
            ResponseEntity<Map<String, Object>> response = restTemplate.exchange(
                    uri,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<>() {}
            );
            
            if (!response.getStatusCode().is2xxSuccessful() || response.getBody() == null) {
                throw new OAuth2IntrospectionException("Invalid Facebook access token");
            }
            
            return new DefaultOAuth2AuthenticatedPrincipal(
                    response.getBody().get("id").toString(),
                    response.getBody(),
                    AuthorityUtils.createAuthorityList("ROLE_USER")
            );
        } catch (Exception e) {
            throw new OAuth2IntrospectionException("Token introspection failed", e);
        }
    }
}
