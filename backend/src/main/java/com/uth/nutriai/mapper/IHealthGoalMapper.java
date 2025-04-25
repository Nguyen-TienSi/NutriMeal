package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.shared.HealthGoalDto;
import com.uth.nutriai.model.enumeration.HealthGoal;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface IHealthGoalMapper {

    HealthGoal mapToHealthGoal(HealthGoalDto healthGoalDto);

    HealthGoalDto mapToHealthGoalDto(HealthGoal healthGoal);
}
