package com.uth.nutriai.utils;

import lombok.experimental.UtilityClass;
import org.springframework.web.util.UriComponentsBuilder;

@UtilityClass
public class UriUtils {

    private static final String FACEBOOK_GRAPH_API_FIELDS = "id,name,email,picture.type(large)";

    public static String buildFacebookGraphApiUrl(String baseUri, String accessToken) {
        return UriComponentsBuilder.fromUriString(baseUri)
                .queryParam("fields", FACEBOOK_GRAPH_API_FIELDS)
                .queryParam("access_token", accessToken)
                .build()
                .toUriString();
    }

    public static String appendToken(String baseUri, String token) {
        if (baseUri == null || token == null) {
            throw new IllegalArgumentException("Base URI and access token cannot be null");
        }

        // If it's a Facebook Graph API URL, use the specific builder
        if (baseUri.contains("graph.facebook.com")) {
            return buildFacebookGraphApiUrl(baseUri, token);
        }

        // For other URLs, use the general approach
        UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(baseUri);
        return builder.queryParam("access_token", token).build().toUriString();
    }

}
