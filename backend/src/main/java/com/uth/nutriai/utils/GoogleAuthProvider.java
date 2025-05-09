package com.uth.nutriai.utils;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.uth.nutriai.dto.internal.UserInfo;
import com.uth.nutriai.security.GoogleTokenVerifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class GoogleAuthProvider implements IAuthProvider {

    @Autowired
    private GoogleTokenVerifier tokenVerifier;

    @Override
    public UserInfo extractUserInfo(String token) {
        GoogleIdToken.Payload payload;
        try {
            payload = tokenVerifier.verify(token);
        } catch (Exception e) {
            return null;
        }

        if (payload == null) {
            return null;
        }

        return UserInfo.builder()
                .userId(payload.getSubject())
                .email(payload.getEmail())
                .name((String) payload.get("name"))
                .pictureUrl((String) payload.get("picture"))
                .authProvider((String) payload.get("iss"))
                .build();
    }
}
