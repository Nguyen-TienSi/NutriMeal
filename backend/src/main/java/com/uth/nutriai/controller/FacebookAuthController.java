package com.uth.nutriai.controller;

import com.uth.nutriai.dto.internal.FacebookUserDto;
import com.uth.nutriai.security.FacebookTokenVerifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.HttpClientErrorException;

import java.util.Map;

@RestController
@RequestMapping(value = "/api/auth/facebook", produces = "application/vnd.company.app-v1+json")
public class FacebookAuthController {

    @Autowired
    private FacebookTokenVerifier facebookTokenVerifier;

    @PostMapping("/exchange-token")
    public ResponseEntity<FacebookUserDto> exchangeTokenWithFacebook(@RequestBody Map<String, String> body) {
        try {
            String accessToken = body.get("accessToken");
            if (accessToken == null) {
                throw new IllegalArgumentException("Missing access_token");
            }
            FacebookUserDto user = facebookTokenVerifier.verify(accessToken);
            return ResponseEntity.ok(user);
        } catch (HttpClientErrorException ex) {
            throw new IllegalArgumentException("Invalid Facebook access token");
        }
    }
}
