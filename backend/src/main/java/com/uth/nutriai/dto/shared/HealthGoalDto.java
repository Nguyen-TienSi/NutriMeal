package com.uth.nutriai.dto.shared;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum HealthGoalDto {
    WEIGHT_LOSS,
    WEIGHT_GAIN,
    MAINTAIN;

    @Override
    public String toString() {
        return name().toLowerCase();
    }

    @JsonCreator
    public static HealthGoalDto fromJson(String value) {
        try {
            return HealthGoalDto.valueOf(value.toUpperCase());
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid health goal: " + value);
        }
    }
}
