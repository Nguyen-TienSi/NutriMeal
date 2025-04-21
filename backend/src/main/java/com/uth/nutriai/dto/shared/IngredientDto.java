package com.uth.nutriai.dto.shared;

public record IngredientDto(
        String name,
        String unit,
        double quantity
) {
}
