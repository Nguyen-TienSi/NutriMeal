package com.uth.nutriai.dto.response;

import com.uth.nutriai.model.entity.FoodItem;

import java.util.List;

public record MealResponseDto(
        BaseResponseDto baseResponseDto,

        String name,
        float calories,
        //Macro nutrients
        float carbs,
        float protein,
        float fat,

        List<FoodItem> ingredients
) {
}
