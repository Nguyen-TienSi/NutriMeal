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

    default List<Map<NutrientDto, Double>> mapToNutrientDtoMapList(List<Map<Nutrient, Double>> nutrientMapList) {
        if (nutrientMapList == null) return List.of();
        return nutrientMapList.stream()
                .map(this::mapToNutrientDtoMap)
                .toList();
    }

    default Map<NutrientDto, Double> mapToNutrientDtoMap(Map<Nutrient, Double> nutrientMap) {
        if (nutrientMap == null) return Map.of();

        return nutrientMap.entrySet().stream()
                .filter(entry -> entry.getKey() != null)
                .collect(Collectors.toMap(
                        entry -> mapToNutrientDto(entry.getKey()),
                        Map.Entry::getValue,
                        (existing, replacement) -> replacement,  // Handle potential key collisions
                        LinkedHashMap::new                       // Preserve insertion order
                ));
    }
}
