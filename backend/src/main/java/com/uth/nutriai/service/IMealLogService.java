package com.uth.nutriai.service;

import com.github.fge.jsonpatch.JsonPatch;
import com.github.fge.jsonpatch.JsonPatchException;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;

import java.io.IOException;
import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface IMealLogService {

    List<MealLogSummaryDto> findMealLogsByTrackingDate(Date trackingDate);

    MealLogDetailDto findMealLogById(UUID id);

    MealLogDetailDto patchMealLog(UUID id, JsonPatch jsonPatch);

    boolean isMealLogAvailable(UUID id);

    String currentEtag(UUID id);

    List<RecipeSummaryDto> findRecipesByMealLogId(UUID id);
}
