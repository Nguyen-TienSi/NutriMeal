package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.UUID;

public record CommentDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        UUID userPostId,
        String content
) {
}
