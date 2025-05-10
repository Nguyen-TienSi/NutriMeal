package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.dto.response.StreakDetailDto;
import com.uth.nutriai.service.IStatisticService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/api/statistics", produces = "application/vnd.company.app-v1+json")
public class StatisticController {

    @Autowired
    private IStatisticService statisticService;

    @GetMapping("/favorite-recipes")
    public ResponseEntity<ApiResponse<List<RecipeSummaryDto>>> findFavoriteRecipesByUser() {
        List<RecipeSummaryDto> recipeSummaryDtoList = statisticService.findFavoriteRecipesByUser();
        if (recipeSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<RecipeSummaryDto>> response = new ApiResponse<>(recipeSummaryDtoList);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/current-month/health-tracking")
    public ResponseEntity<ApiResponse<List<HealthTrackingDetailDto>>> findHealthTrackingByCurrentMonth() {
        List<HealthTrackingDetailDto> healthTrackingDetailDtoList = statisticService.findHealthTrackingByUserAndTrackingDateBetween();
        if (healthTrackingDetailDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<HealthTrackingDetailDto>> response = new ApiResponse<>(healthTrackingDetailDtoList);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/streaks")
    public ResponseEntity<ApiResponse<StreakDetailDto>> findStreakByUser() {
        StreakDetailDto streakDetailDto = statisticService.findStreak();
        if (streakDetailDto == null) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<StreakDetailDto> response = new ApiResponse<>(streakDetailDto);
        return ResponseEntity.ok(response);
    }
}
