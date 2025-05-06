package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.TimeOfDayDto;

import java.util.Date;
import java.util.UUID;

public record MealLogSummaryDto(
        UUID id,
        @JsonProperty("timeOfDay") TimeOfDayDto timeOfDayDto,
        Date trackingDate,
        double totalCalories,
        double consumedCalories
) {
}
