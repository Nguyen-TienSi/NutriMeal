package com.uth.nutriai.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.annotation.AllowedEnum;
import com.uth.nutriai.dto.shared.ActivityLevelDto;
import com.uth.nutriai.dto.shared.HealthGoalDto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;

public record UserCreateDto(

        String userId,
        String name,
        String email,
        String pictureUrl,
        String authProvider,

        @JsonProperty("activityLevel")
        @NotNull(message = "Activity level is required")
        @Valid
        @AllowedEnum(enumClass = ActivityLevelDto.class, allowed = {"INACTIVE", "NORMAL", "ACTIVE"})
        ActivityLevelDto activityLevelDto,

        @JsonProperty("healthGoal")
        @NotNull(message = "Health goal is required")
        @Valid
        @AllowedEnum(enumClass = HealthGoalDto.class, allowed = {"WEIGHT_LOSS", "WEIGHT_GAIN", "MAINTAIN"})
        HealthGoalDto healthGoalDto,

        @Min(value = 20, message = "Current weight must be at least 20kg")
        @Max(value = 300, message = "Current weight must be less than 300kg")
        int currentWeight,

        @Min(value = 20, message = "Target weight must be at least 20kg")
        @Max(value = 300, message = "Target weight must be less than 300kg")
        int targetWeight,

        @Min(value = 50, message = "Height must be at least 50cm")
        @Max(value = 300, message = "Height must be less than 300cm")
        int currentHeight

) {
}
