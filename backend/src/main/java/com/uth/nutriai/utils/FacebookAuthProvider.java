package com.uth.nutriai.utils;

import com.uth.nutriai.dto.internal.FacebookUserDto;
import com.uth.nutriai.dto.internal.UserInfo;
import com.uth.nutriai.security.FacebookTokenVerifier;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class FacebookAuthProvider implements IAuthProvider {

    @Autowired
    private FacebookTokenVerifier tokenVerifier;

    @Override
    public UserInfo extractUserInfo(String token) {
        FacebookUserDto facebookUser;
        try {
            facebookUser = tokenVerifier.verify(token);
        } catch (Exception e) {
            return null;
        }

        if (facebookUser == null) {
            return null;
        }

        return UserInfo.builder()
                .userId(facebookUser.getId())
//                .email(facebookUser.getEmail())
                .name(facebookUser.getName())
                .pictureUrl(facebookUser.getPicture().getData().getUrl())
                .authProvider("facebook")
                .build();
    }
}
