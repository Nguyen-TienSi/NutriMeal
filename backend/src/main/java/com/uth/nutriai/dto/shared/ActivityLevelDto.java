package com.uth.nutriai.dto.shared;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum ActivityLevelDto {
    INACTIVE,
    NORMAL,
    ACTIVE;

    @Override
    public String toString() {
        return name().toLowerCase();
    }

    @JsonCreator
    public static ActivityLevelDto fromJson(String value) {
        try {
            return ActivityLevelDto.valueOf(value.toUpperCase());
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid activity level: " + value);
        }
    }
}
