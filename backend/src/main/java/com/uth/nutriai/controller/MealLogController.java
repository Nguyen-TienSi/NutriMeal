package com.uth.nutriai.controller;

import com.github.fge.jsonpatch.JsonPatch;
import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.service.IMealLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/meal-logs", produces = "application/vnd.company.app-v1+json")
public class MealLogController {

    @Autowired
    private IMealLogService mealLogService;

    @GetMapping("/{date}")
    public ResponseEntity<ApiResponse<List<MealLogSummaryDto>>> findMealLogsByDate(
            @PathVariable("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date trackingDate
    ) {
        List<MealLogSummaryDto> mealLogSummaryDtoList = mealLogService.findMealLogsByTrackingDate(trackingDate);
        if (mealLogSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<MealLogSummaryDto>> response = new ApiResponse<>(mealLogSummaryDtoList);
        return ResponseEntity.ok(response);
    }

    @RequestMapping(value = "/search", method = {RequestMethod.GET, RequestMethod.HEAD})
    public ResponseEntity<ApiResponse<MealLogDetailDto>> findMealLogById(
            @RequestParam UUID id,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {

        if (!mealLogService.isMealLogAvailable(id)) {
            return ResponseEntity.notFound().build();
        }

        if (eTag != null && eTag.equals(mealLogService.currentEtag(id))) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        MealLogDetailDto mealLogDetailDto = mealLogService.findMealLogById(id);

        ApiResponse<MealLogDetailDto> response = new ApiResponse<>(mealLogDetailDto);
        return ResponseEntity.ok()
                .eTag(mealLogService.currentEtag(id))
                .body(response);
    }

    @PatchMapping(path = "/{id}", consumes = "application/json-patch+json")
    public ResponseEntity<ApiResponse<MealLogDetailDto>> patchMealLog(
            @PathVariable("id") UUID id,
            @RequestBody JsonPatch patch,
            @RequestHeader(value = "If-Match", required = false) String eTag
    ) {
        if (!mealLogService.isMealLogAvailable(id)) {
            return ResponseEntity.notFound().build();
        }

        if (eTag == null || !eTag.equals(mealLogService.currentEtag(id))) {
            return ResponseEntity.status(HttpStatus.PRECONDITION_FAILED).build();
        }

        MealLogDetailDto mealLogDetailDto = mealLogService.patchMealLog(id, patch);

        ApiResponse<MealLogDetailDto> response = new ApiResponse<>(mealLogDetailDto);
        return ResponseEntity.ok()
                .eTag(mealLogService.currentEtag(id))
                .body(response);
    }

    @GetMapping("/{id}/recipes")
    public ResponseEntity<ApiResponse<List<RecipeSummaryDto>>> findRecipesByMealLogId(
            @PathVariable("id") UUID id
    ) {
        List<RecipeSummaryDto> recipeSummaryDtoList = mealLogService.findRecipesByMealLogId(id);
        if (recipeSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<RecipeSummaryDto>> response = new ApiResponse<>(recipeSummaryDtoList);
        return ResponseEntity.ok(response);
    }
}
