package com.uth.nutriai.service;

import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.dto.response.StreakDetailDto;

import java.util.List;

public interface IStatisticService {

    List<RecipeSummaryDto> findFavoriteRecipesByUser();

    List<HealthTrackingDetailDto> findHealthTrackingByUserAndTrackingDateBetween();

    StreakDetailDto findStreak();
}
