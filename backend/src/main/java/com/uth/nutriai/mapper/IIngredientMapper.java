package com.uth.nutriai.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.uth.nutriai.dto.shared.IngredientDto;
import com.uth.nutriai.model.domain.Ingredient;

@Mapper(componentModel = "spring")
public interface IIngredientMapper {

    Ingredient mapToIngredient(IngredientDto ingredientDto);

    IngredientDto mapToIngredientDto(Ingredient ingredient);

    List<IngredientDto> mapIngredientDtoList(List<Ingredient> ingredientList);
}
