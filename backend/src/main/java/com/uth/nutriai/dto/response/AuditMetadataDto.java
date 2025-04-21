package com.uth.nutriai.dto.response;

import com.uth.nutriai.model.BaseEntity;

import java.util.Date;
import java.util.UUID;

public record AuditMetadataDto(
        UUID createdBy,
        UUID lastModifiedBy,
        Date createdAt,
        Date lastModifiedAt,
        Long version,
        boolean isDeleted
) {
    public AuditMetadataDto(BaseEntity baseEntity) {
        this(
                baseEntity.getCreatedBy(),
                baseEntity.getLastModifiedBy(),
                baseEntity.getCreatedAt(),
                baseEntity.getLastModifiedAt(),
                baseEntity.getVersion(),
                baseEntity.isDeleted()
        );
    }

    public static AuditMetadataDto of(BaseEntity baseEntity) {
        return new AuditMetadataDto(baseEntity);
    }
}
