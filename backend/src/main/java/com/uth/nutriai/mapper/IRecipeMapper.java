package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.model.domain.Recipe;
import org.mapstruct.AfterMapping;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingTarget;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;

import java.time.Duration;
import java.util.List;

@Mapper(componentModel = "spring", uses = {
        IIngredientMapper.class,
        IFoodTagMapper.class,
        INutrientMapper.class,
        ITimeOfDayMapper.class,
})
public interface IRecipeMapper {

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
    @Mapping(target = "nutrientDtoList", source = "nutrients")
    RecipeDetailDto mapToRecipeDetailDto(Recipe recipe);

    @Mapping(target = "timesOfDay", source = "timeOfDayDtoList")
    @Mapping(target = "cookingTime", expression = "java(mapToDuration(recipeUpdateDto.cookingTime()))")
    @Mapping(target = "ingredients", source = "ingredientDtoList")
    @Mapping(target = "foodTags", source = "foodTagDtoList")
    @Mapping(target = "nutrients", source = "nutrientDtoList")
    @Mapping(target = "id", ignore = true)
    Recipe mapToRecipe(RecipeUpdateDto recipeUpdateDto);

    @Mapping(target = "timeOfDayDtoList", source = "timesOfDay")
    @Mapping(target = "nutrientDtoList", source = "nutrients")
    @Mapping(target = "calories", ignore = true)
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

    @AfterMapping
    default void afterMappingToRecipeSummaryDto(@MappingTarget RecipeSummaryDto recipeSummaryDto, Recipe recipe) {
        recipeSummaryDto = new RecipeSummaryDto(
                recipeSummaryDto.id(),
                recipe.getRecipeName(),
                recipe.getImageUrl(),
                recipe.getServing(),
                recipe.getServingUnit(),
                recipeSummaryDto.getCalories(),
                recipeSummaryDto.nutrientDtoList(),
                recipeSummaryDto.timeOfDayDtoList()
        );
    }

}
