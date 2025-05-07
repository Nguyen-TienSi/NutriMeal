package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.utils.INutritionCalculator;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;
import java.util.UUID;

@Mapper(componentModel = "spring", uses = {
        ITimeOfDayMapper.class,
        INutrientMapper.class,
})
public interface IMealLogMapper extends INutritionCalculator<MealLog> {

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(mealLog))")
    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "timeOfDayDto", source = "timeOfDay")
    @Mapping(target = "trackingDate", source = "trackingDate")
    @Mapping(target = "recipeIdList", expression = "java(mapToRecipeIdList(mealLog.getRecipeList()))")
    @Mapping(target = "consumedCalories", expression = "java(calculateCalories(mealLog))")
    @Mapping(target = "consumedNutrientDtoList", source = "consumedNutrients")
    @Mapping(target = "totalNutrientDtoList", source = "totalNutrients")
    MealLogDetailDto mapToMealLogDetailDto(MealLog mealLog);

    @Mapping(target = "timeOfDayDto", source = "timeOfDay")
    @Mapping(target = "trackingDate", source = "trackingDate")
    @Mapping(target = "consumedCalories", expression = "java(calculateCalories(mealLog))")
    MealLogSummaryDto mapToMealLogSummaryDto(MealLog mealLog);

    List<MealLogSummaryDto> mapToMealLogSummaryDtoList(List<MealLog> mealLogList);

    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "trackingDate", source = "trackingDate")
    @Mapping(target = "recipeIdList", expression = "java(mapToRecipeIdList(mealLog.getRecipeList()))")
    @Mapping(target = "consumedNutrientDtoList", source = "consumedNutrients")
    @Mapping(target = "totalNutrientDtoList", source = "totalNutrients")
    MealLogUpdateDto mapToMealLogUpdateDto(MealLog mealLog);

    default List<UUID> mapToRecipeIdList(List<Recipe> recipeList) {
        if (recipeList == null) return List.of();
        return recipeList.stream().map(Recipe::getId).toList();
    }

    @Override
    default List<Nutrient> getConsumedNutrients(MealLog entity) {
        return entity.getConsumedNutrients();
    }
}
