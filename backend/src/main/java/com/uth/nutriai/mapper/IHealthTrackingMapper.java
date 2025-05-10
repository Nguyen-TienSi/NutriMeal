package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.utils.INutritionCalculator;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", uses = {
        INutrientMapper.class,
})
public interface IHealthTrackingMapper extends INutritionCalculator<HealthTracking> {

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(healthTracking))")
    @Mapping(target = "userId", source = "user.id")
    @Mapping(target = "consumedCalories", expression = "java(calculateCalories(healthTracking))")
    @Mapping(target = "consumedNutrientDtoList", source = "consumedNutrients")
    @Mapping(target = "totalNutrientDtoList", source = "totalNutrients")
    HealthTrackingDetailDto mapToHealthTrackingDetailDto(HealthTracking healthTracking);

    List<HealthTrackingDetailDto> mapToHealthTrackingDetailDtoList(List<HealthTracking> healthTrackingList);

    @Override
    default List<Nutrient> getConsumedNutrients(HealthTracking entity) {
        return entity.getConsumedNutrients();
    }
}
