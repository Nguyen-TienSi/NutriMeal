package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import com.uth.nutriai.model.enumeration.HealthGoal;

import java.util.UUID;

public record UserDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        String name,
        ActivityLevel activityLevel,
        HealthGoal healthGoal,
        int currentWeight,
        int targetWeight,
        int currentHeight
) {
}
