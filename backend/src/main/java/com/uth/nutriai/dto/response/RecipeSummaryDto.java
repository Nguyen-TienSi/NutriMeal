package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.dto.shared.TimeOfDayDto;
import com.uth.nutriai.utils.NutritionCalculator;

import java.util.List;
import java.util.UUID;

public record RecipeSummaryDto(
        UUID id,
        String recipeName,
        String imageUrl,
        float serving,
        String servingUnit,
        String calories,

        @JsonIgnore List<NutrientDto> nutrientDtoList,

        @JsonProperty("timesOfDay") List<TimeOfDayDto> timeOfDayDtoList
) implements NutritionCalculator {
    @Override
    public double calculateNutrients() {
        double protein = 0;
        double carbs = 0;
        double fat = 0;

        for (NutrientDto nutrient : nutrientDtoList) {
            String name = nutrient.name().toLowerCase();
            switch (name) {
                case "protein" -> protein = nutrient.value();
                case "carbohydrates", "carbs" -> carbs = nutrient.value();
                case "fat" -> fat = nutrient.value();
            }
        }

        return protein * 4 + carbs * 4 + fat * 9;
    }

    public String getCalories() {
        return String.format("%.2f kcal", calculateNutrients());
    }
}
