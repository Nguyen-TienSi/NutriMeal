package com.uth.nutriai.dto.request;

import com.uth.nutriai.model.entity.FoodItem;
import org.springframework.data.mongodb.core.mapping.DBRef;

import java.time.Instant;
import java.util.List;
import java.util.UUID;

public record MealRequestDto(
        String name,
        float calories,
        //Macro nutrients
        float carbs,
        float protein,
        float fat,

        List<FoodItem> ingredients
) {
}
