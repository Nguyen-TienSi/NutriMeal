package com.uth.nutriai.security;

import com.uth.nutriai.dto.internal.FacebookUserDto;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

@Component
public class FacebookTokenVerifier {

    @Value("${spring.security.oauth2.client.provider.facebook.user-info-uri}")
    private String userInfoUri;

    public FacebookUserDto verify(String accessToken) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            String url = userInfoUri + accessToken;

            ResponseEntity<FacebookUserDto> response = restTemplate.exchange(
                    url,
                    HttpMethod.GET,
                    null,
                    new ParameterizedTypeReference<>() {}
            );

            if (!response.getStatusCode().is2xxSuccessful() || response.getBody() == null) {
                throw new RuntimeException("Invalid Facebook access token");
            }

            return response.getBody();

        } catch (Exception e) {
            throw new RuntimeException("Token verification failed: " + e.getMessage(), e);
        }
    }
}
