package com.uth.nutriai.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.uth.nutriai.security.GoogleTokenVerifier;
import com.uth.nutriai.service.IUserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.http.*;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.jwt.JwtDecoder;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping(value = "/api/auth/google", produces = "application/vnd.company.app-v1+json")
public class GoogleAuthController {

    @Value("${spring.security.oauth2.client.registration.google.client-id}")
    private String clientId;
    @Value("${spring.security.oauth2.client.registration.google.client-secret}")
    private String clientSecret;
    @Value("${spring.security.oauth2.client.registration.google.redirect-uri}")
    private String redirectUri;

    @Autowired
    private JwtDecoder jwtDecoder;

    @Autowired
    private GoogleTokenVerifier googleTokenVerifier;

    @Autowired
    private IUserService userService;

    @PostMapping("/exchange-token")
    public ResponseEntity<?> exchangeTokenWithGoogle(@RequestBody Map<String, String> body) {
        String code = body.get("serverAuthCode");
        if (code == null) {
            return ResponseEntity.badRequest().body("Missing serverAuthCode");
        }

        // 1) Exchange code for tokens
        RestTemplate rt = new RestTemplate();
        MultiValueMap<String, String> form = new LinkedMultiValueMap<>();
        form.add("code", code);
        form.add("client_id", clientId);
        form.add("client_secret", clientSecret);
        form.add("redirect_uri", redirectUri);
        form.add("grant_type", "authorization_code");

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);

        HttpEntity<MultiValueMap<String, String>> req = new HttpEntity<>(form, headers);
        Map<String, Object> tokenResponse = rt.exchange(
                "https://oauth2.googleapis.com/token",
                HttpMethod.POST,
                req,
                new ParameterizedTypeReference<Map<String, Object>>() {
                }
        ).getBody();

        if (tokenResponse == null) {
            return ResponseEntity.badRequest().body("Failed to retrieve token from Google");
        }

        String idToken = (String) tokenResponse.get("id_token");
        String accessToken = (String) tokenResponse.get("access_token");
        String refreshToken = (String) tokenResponse.get("refresh_token");

        // 2) Verify id_token (JWT) and extract user info
        Jwt jwt = jwtDecoder.decode(idToken);

        Map<String, Object> result = new HashMap<>();
        result.put("idToken", idToken);
        result.put("accessToken", accessToken);
        result.put("refreshToken", refreshToken);

        return ResponseEntity.ok(result);
    }

    @PostMapping("/verify-user")
    public ResponseEntity<?> authenticateWithGoogle(@RequestHeader("Authorization") String authHeader) {

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Missing or invalid Authorization header");
        }

        String idToken = authHeader.substring(7);
        GoogleIdToken.Payload userPayload = googleTokenVerifier.verify(idToken);

        String sub = userPayload.getSubject();

        if (userService.isUserAvailable(sub)) {
            return ResponseEntity.ok().build();
        } else {
            return ResponseEntity.notFound().build();
        }
    }

}
