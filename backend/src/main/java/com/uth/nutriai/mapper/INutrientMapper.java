package com.uth.nutriai.mapper;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.mapstruct.Mapper;

import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.model.domain.Nutrient;

@Mapper(componentModel = "spring")
public interface INutrientMapper {

    Nutrient mapToNutrient(NutrientDto nutrientDto);

    NutrientDto mapToNutrientDto(Nutrient nutrient);

    List<NutrientDto> mapToNutrientDtoList(List<Nutrient> nutrientList);
}
