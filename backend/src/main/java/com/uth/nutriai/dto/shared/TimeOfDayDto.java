package com.uth.nutriai.dto.shared;

import com.fasterxml.jackson.annotation.JsonCreator;

public enum TimeOfDayDto {
    MORNING,
    NOON,
    AFTERNOON,
    EVENING,
    NIGHT;

    @Override
    public String toString() {
        return name().toLowerCase();
    }

    @JsonCreator
    public static TimeOfDayDto fromJson(String value) {
        try {
            return TimeOfDayDto.valueOf(value.toUpperCase());
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid time of day: " + value);
        }
    }
}
