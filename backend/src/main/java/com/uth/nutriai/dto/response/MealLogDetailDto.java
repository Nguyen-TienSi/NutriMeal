package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.dto.shared.TimeOfDayDto;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public record MealLogDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        UUID userId,
        List<UUID> recipeIdList,
        @JsonProperty("timeOfDay") TimeOfDayDto timeOfDayDto,
        Date mealDate,
        double totalCalories,
        double consumedCalories,
        List<Map<NutrientDto, Double>> consumedNutrients
) {
}
