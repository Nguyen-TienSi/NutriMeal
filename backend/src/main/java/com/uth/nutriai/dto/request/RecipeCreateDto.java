package com.uth.nutriai.dto.request;

import com.uth.nutriai.annotation.AllowedEnum;
import com.uth.nutriai.dto.shared.FoodTagDto;
import com.uth.nutriai.dto.shared.IngredientDto;
import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.dto.shared.TimeOfDayDto;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;
import com.fasterxml.jackson.annotation.JsonProperty;

import java.util.List;

public record RecipeCreateDto(

        @NotBlank(message = "Recipe name must not be blank")
        String recipeName,

        @NotBlank(message = "Description is required")
        String description,

        @NotBlank(message = "Instructions are required")
        String instructions,

        @NotBlank(message = "Image URL is required")
        String imageUrl,

        @NotNull(message = "Cooking time must be provided")
        @Min(value = 1, message = "Cooking time must be at least 1 minute")
        Long cookingTime,

        @Min(value = 1, message = "Serving must be at least 1")
        int serving,

        @NotBlank(message = "Serving unit is required")
        String servingUnit,

        @JsonProperty("ingredients")
        @NotNull(message = "Ingredients are required")
        @Size(min = 1, message = "At least 1 ingredient is required")
        List<@Valid IngredientDto> ingredientDtoList,

        @JsonProperty("foodTags")
        @NotNull(message = "Food tags are required")
        List<@Valid FoodTagDto> foodTagDtoList,

        @JsonProperty("nutrients")
        @NotNull(message = "Nutrients are required")
        List<@Valid NutrientDto> nutrientDtoList,

        @JsonProperty("timesOfDay")
        @NotNull(message = "Time of day is required")
        @Valid
        List<@AllowedEnum(
                enumClass = TimeOfDayDto.class,
                allowed = { "morning", "noon", "afternoon", "evening", "night" }
        ) @Valid TimeOfDayDto> timeOfDayDtoList

) {
}
