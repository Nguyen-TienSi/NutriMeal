package com.uth.nutriai.dto.response;

import java.time.Instant;
import java.util.UUID;

public record BaseResponseDto(
        UUID id,
        Instant createAt,
        Instant lastModifiedAt,
        boolean isDeleted,
        Long version
) {
}
