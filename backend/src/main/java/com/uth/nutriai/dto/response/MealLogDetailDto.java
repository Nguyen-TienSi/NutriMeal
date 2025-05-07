package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.dto.shared.TimeOfDayDto;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public record MealLogDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        UUID userId,
        @JsonProperty("recipeIds") List<UUID> recipeIdList,
        @JsonProperty("timeOfDay") TimeOfDayDto timeOfDayDto,
        Date trackingDate,
        double totalCalories,
        double consumedCalories,
        @JsonProperty("consumedNutrients") List<NutrientDto> consumedNutrientDtoList,
        @JsonProperty("totalNutrients") List<NutrientDto> totalNutrientDtoList
) {
}
