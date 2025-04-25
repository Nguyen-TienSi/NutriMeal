package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.NutrientDto;
import com.uth.nutriai.dto.shared.TimeOfDayDto;

import java.util.List;
import java.util.UUID;

public record RecipeSummaryDto(
        UUID id,
        String recipeName,
        String imageUrl,
        float serving,
        String servingUnit,
        String calories,

        @JsonProperty("timesOfDay") List<TimeOfDayDto> timeOfDayDtoList
) {
}
