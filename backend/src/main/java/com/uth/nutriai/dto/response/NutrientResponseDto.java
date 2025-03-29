package com.uth.nutriai.dto.response;

public record NutrientResponseDto(
        BaseResponseDto baseResponseDto,
        String name,
        String unit,
        float dailyValue
) {
}
