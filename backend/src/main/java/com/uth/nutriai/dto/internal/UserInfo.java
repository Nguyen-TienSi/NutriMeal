package com.uth.nutriai.dto.internal;

import lombok.Builder;

@Builder
public record UserInfo(
        String userId,
        String email,
        String name,
        String pictureUrl,
        String authProvider
) {
}
