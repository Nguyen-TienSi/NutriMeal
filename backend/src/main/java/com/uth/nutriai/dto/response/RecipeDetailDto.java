package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.FoodTagDto;
import com.uth.nutriai.dto.shared.IngredientDto;
import com.uth.nutriai.dto.shared.NutrientDto;

import java.util.List;
import java.util.UUID;

public record RecipeDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        String recipeName,
        String description,
        String instructions,
        String imageUrl,
        Long cookingTime,
        float serving,
        String servingUnit,

        @JsonProperty("ingredients") List<IngredientDto> ingredientDtoList,
        @JsonProperty("foodTags") List<FoodTagDto> foodTagDtoList,
        @JsonProperty("nutrients") List<NutrientDto> nutrientDtoList
) {
}
