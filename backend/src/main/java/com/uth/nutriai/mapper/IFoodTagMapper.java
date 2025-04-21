package com.uth.nutriai.mapper;

import java.util.List;

import org.mapstruct.Mapper;
import com.uth.nutriai.dto.shared.FoodTagDto;
import com.uth.nutriai.model.domain.FoodTag;

@Mapper(componentModel = "spring")
public interface IFoodTagMapper {

    FoodTag mapToFoodTag(FoodTagDto tagDto);

    FoodTagDto mapToFoodTagDto(FoodTag tag);

    List<FoodTagDto> mapFoodTagDtoList(List<FoodTag> tagList);
}
