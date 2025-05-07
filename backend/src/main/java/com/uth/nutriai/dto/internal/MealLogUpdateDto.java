package com.uth.nutriai.dto.internal;

import com.uth.nutriai.dto.shared.NutrientDto;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public record MealLogUpdateDto(
        UUID id,
        UUID userId,
        List<UUID> recipeIdList,
        Date trackingDate,
        double totalCalories,
        List<NutrientDto> consumedNutrientDtoList,
        List<NutrientDto> totalNutrientDtoList
) {
}
