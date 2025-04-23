package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.shared.TimeOfDayDto;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ITimeOfDayMapper {
    TimeOfDay mapToTimeOfDay(TimeOfDayDto timeOfDayDto);
    TimeOfDayDto mapToTimeOfDayDto(TimeOfDay timeOfDay);

    default List<TimeOfDay> mapToTimeOfDayList(List<TimeOfDayDto> timeOfDayDtoList) {
        return timeOfDayDtoList == null ? null : timeOfDayDtoList.stream().map(this::mapToTimeOfDay).toList();
    }

    default List<TimeOfDayDto> mapToTimeOfDayDtoList(List<TimeOfDay> timeOfDayList) {
        return timeOfDayList == null ? null : timeOfDayList.stream().map(this::mapToTimeOfDayDto).toList();
    }
}
