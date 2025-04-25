package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.UUID;

public record UserPostDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        String content,
        String imageUrl,
        int likeCount,
        int commentCount,
        int shareCount
) {
}
