package com.uth.nutriai.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.uth.nutriai.dto.shared.NutrientDto;

import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public record HealthTrackingDetailDto(
        UUID id,
        @JsonProperty("meta") AuditMetadataDto auditMetadataDto,
        UUID userId,
        Date trackingDate,
        double totalCalories,
        double consumedCalories,
        List<Map<NutrientDto, Double>> consumedNutrients
) {
}
