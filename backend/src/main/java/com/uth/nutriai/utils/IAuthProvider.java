package com.uth.nutriai.utils;

import com.uth.nutriai.dto.internal.UserInfo;

public interface IAuthProvider {
    UserInfo extractUserInfo(String token);
}
