package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.utils.INutritionCalculator;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;

import java.time.Duration;
import java.util.List;
import java.util.Map;

@Mapper(componentModel = "spring", uses = {
        IIngredientMapper.class,
        IFoodTagMapper.class,
        INutrientMapper.class,
        ITimeOfDayMapper.class,
})
public interface IRecipeMapper extends INutritionCalculator<Recipe> {

    @Mapping(target = "timesOfDay", source = "timeOfDayDtoList")
    @Mapping(target = "cookingTime", expression = "java(mapToDuration(recipeCreateDto.cookingTime()))")
    @Mapping(target = "ingredients", source = "ingredientDtoList")
    @Mapping(target = "foodTags", source = "foodTagDtoList")
    @Mapping(target = "nutrients", source = "nutrientDtoList")
    Recipe mapToRecipe(RecipeCreateDto recipeCreateDto);

    @Mapping(target = "timeOfDayDtoList", source = "timesOfDay")
    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(recipe))")
    @Mapping(target = "cookingTime", expression = "java(mapToLong(recipe.getCookingTime()))")
    @Mapping(target = "ingredientDtoList", source = "ingredients")
    @Mapping(target = "foodTagDtoList", source = "foodTags")
    RecipeDetailDto mapToRecipeDetailDto(Recipe recipe);

    @Mapping(target = "timesOfDay", source = "timeOfDayDtoList")
    @Mapping(target = "cookingTime", expression = "java(mapToDuration(recipeUpdateDto.cookingTime()))")
    @Mapping(target = "ingredients", source = "ingredientDtoList")
    @Mapping(target = "foodTags", source = "foodTagDtoList")
    @Mapping(target = "nutrients", source = "nutrientDtoList")
    @Mapping(target = "id", ignore = true)
    Recipe mapToRecipe(RecipeUpdateDto recipeUpdateDto);

    @Mapping(target = "timeOfDayDtoList", source = "timesOfDay")
    @Mapping(target = "calories", expression = "java(getCalories(recipe))")
    RecipeSummaryDto mapToRecipeSummaryDto(Recipe recipe);

    List<RecipeSummaryDto> mapToRecipeSummaryDtoList(List<Recipe> recipeList);

    default Page<RecipeSummaryDto> mapToRecipeSummaryDtoPage(Page<Recipe> recipePage) {
        List<RecipeSummaryDto> recipeSummaryDtoList = mapToRecipeSummaryDtoList(recipePage.getContent());
        return new PageImpl<>(recipeSummaryDtoList, recipePage.getPageable(), recipePage.getTotalElements());
    }

    default Duration mapToDuration(Long minutes) {
        return minutes == null ? null : Duration.ofMinutes(minutes);
    }

    default Long mapToLong(Duration duration) {
        return duration == null ? null : duration.toMinutes();
    }

    @Override
    default double calculateCalories(Recipe entity) {
        double protein = 0;
        double carbs = 0;
        double fat = 0;

        for (Nutrient nutrient : entity.getNutrients()) {
            String name = nutrient.getName().toLowerCase();
            switch (name) {
                case "protein" -> protein = nutrient.getValue();
                case "carbohydrates", "carbs" -> carbs = nutrient.getValue();
                case "fat" -> fat = nutrient.getValue();
            }
        }

        return protein * 4 + carbs * 4 + fat * 9;
    }

    default String getCalories(Recipe recipe) {
        return String.format("%.2f kcal", calculateCalories(recipe));
    }

    @Override
    default List<Map<Nutrient, Double>> getConsumedNutrients(Recipe entity) {
        return null;
    };
}
