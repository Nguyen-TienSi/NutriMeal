package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.dto.response.HealthTrackingSummaryDto;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.utils.INutritionCalculator;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

import java.util.List;
import java.util.Map;

@Mapper(componentModel = "spring", uses = {
        INutrientMapper.class,
})
public interface IHealthTrackingMapper extends INutritionCalculator<HealthTracking> {

    INutrientMapper nutrientMapper = Mappers.getMapper(INutrientMapper.class);

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(healthTracking))")
    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "consumedCalories", expression = "java(calculateCalories(healthTracking))")
    @Mapping(target = "consumedNutrients", expression = "java(nutrientMapper.mapToNutrientDtoMapList(healthTracking.getConsumedNutrients()))")
    HealthTrackingSummaryDto mapToHealthTrackingSummaryDto(HealthTracking healthTracking);

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(healthTracking))")
    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "consumedCalories", expression = "java(calculateCalories(healthTracking))")
    @Mapping(target = "consumedNutrients", expression = "java(nutrientMapper.mapToNutrientDtoMapList(healthTracking.getConsumedNutrients()))")
    HealthTrackingDetailDto mapToHealthTrackingDetailDto(HealthTracking healthTracking);

    @Override
    default List<Map<Nutrient, Double>> getConsumedNutrients(HealthTracking entity) {
        return entity.getConsumedNutrients();
    }
}
