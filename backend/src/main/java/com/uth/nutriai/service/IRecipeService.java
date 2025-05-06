package com.uth.nutriai.service;

import java.util.List;
import java.util.UUID;

import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;

public interface IRecipeService {

    List<RecipeSummaryDto> findAllRecipes();

    boolean isRecipeAvailable(UUID id);

    RecipeDetailDto findRecipeById(UUID id);

    RecipeDetailDto createRecipe(RecipeCreateDto recipeCreateDto);

    RecipeDetailDto updateRecipe(RecipeUpdateDto recipeUpdateDto);

    void deleteRecipe(UUID id);

    List<RecipeSummaryDto> findRecipesByMealTime(String mealTime);

    boolean isRecipeAvailable(String fieldName, Object fieldValue);

    List<RecipeSummaryDto> findRecipesByField(String fieldName, Object fieldValue);

    String currentEtag(UUID id);
}
