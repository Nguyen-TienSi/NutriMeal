package com.uth.nutriai.service;

import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface IMealLogService {

    List<MealLogSummaryDto> findMealLogsByDate(Date mealDate);

    MealLogDetailDto findMealLogById(UUID id);

    boolean isMealLogAvailable(UUID id);

    String currentEtag(UUID id);
}
