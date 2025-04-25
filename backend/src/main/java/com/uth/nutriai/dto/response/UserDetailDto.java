package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.ActivityLevelDto;
import com.uth.nutriai.dto.shared.HealthGoalDto;

import java.util.UUID;

public record UserDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        String userId,
        String name,
        String email,
        String pictureUrl,
        String authProvider,
        @JsonProperty("activityLevel") ActivityLevelDto activityLevelDto,
        @JsonProperty("healthGoal") HealthGoalDto healthGoalDto,
        int currentWeight,
        int targetWeight,
        int currentHeight
) {
}
