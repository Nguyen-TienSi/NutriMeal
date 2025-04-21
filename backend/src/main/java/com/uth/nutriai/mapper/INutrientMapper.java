package com.uth.nutriai.mapper;

import java.util.List;

import org.mapstruct.Mapper;

import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.model.domain.Nutrient;

@Mapper(componentModel = "spring")
public interface INutrientMapper {

    Nutrient mapToNutrient(NutrientDto nutrientDto);

    NutrientDto mapToNutrientDto(Nutrient nutrient);

    List<NutrientDto> mapToNutrientDtoList(List<Nutrient> nutrientList);
}
