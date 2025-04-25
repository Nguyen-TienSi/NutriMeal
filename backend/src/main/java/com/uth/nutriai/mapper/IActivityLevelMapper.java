package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.shared.ActivityLevelDto;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import org.mapstruct.Mapper;

@Mapper(componentModel = "spring")
public interface IActivityLevelMapper {

    ActivityLevel mapToActivityLevel(ActivityLevelDto activityLevelDto);

    ActivityLevelDto mapToActivityLevelDto(ActivityLevel activityLevel);
}
