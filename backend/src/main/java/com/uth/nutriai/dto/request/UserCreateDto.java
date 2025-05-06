package com.uth.nutriai.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.annotation.AllowedEnum;
import com.uth.nutriai.dto.shared.ActivityLevelDto;
import com.uth.nutriai.dto.shared.HealthGoalDto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;

import java.util.Date;

public record UserCreateDto(

        @NotNull(message = "Gender is required")
        @Pattern(regexp = "^(male|female|other)$", message = "Gender must be male, female or other")
        String gender,

        @NotNull(message = "Date of birth is required")
        @Past(message = "Date of birth must be in the past")
        Date dateOfBirth,
        
        @JsonProperty("activityLevel")
        @NotNull(message = "Activity level is required")
        @Valid
        @AllowedEnum(enumClass = ActivityLevelDto.class, allowed = {"inactive", "normal", "active"})
        ActivityLevelDto activityLevelDto,

        @JsonProperty("healthGoal")
        @NotNull(message = "Health goal is required")
        @Valid
        @AllowedEnum(enumClass = HealthGoalDto.class, allowed = {"weight_loss", "weight_gain", "maintain"})
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
