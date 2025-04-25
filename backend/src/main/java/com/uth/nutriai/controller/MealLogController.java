package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.service.IMealLogService;
import org.springframework.beans.factory.annotation.Autowired;
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

    @GetMapping("/date")
    public ResponseEntity<ApiResponse<List<MealLogSummaryDto>>> findMealLogsByDate(@RequestParam Date date) {
        List<MealLogSummaryDto> mealLogSummaryDtoList = mealLogService.findMealLogsByDate(date);
        if (mealLogSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<MealLogSummaryDto>> response = new ApiResponse<>(mealLogSummaryDtoList);
        return ResponseEntity.ok(response);
    }

    @RequestMapping(value = "/date/search", method = {RequestMethod.GET, RequestMethod.HEAD})
    public ResponseEntity<ApiResponse<MealLogDetailDto>> findMealLogById(
            @RequestParam UUID id,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {

        if(!mealLogService.isMealLogAvailable(id)) {
            return ResponseEntity.notFound().build();
        }

        String currentEtag = mealLogService.currentEtag(id);

        if(eTag != null && eTag.equals(currentEtag)) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        MealLogDetailDto mealLogDetailDto = mealLogService.findMealLogById(id);

        ApiResponse<MealLogDetailDto> response = new ApiResponse<>(mealLogDetailDto);
        return ResponseEntity.ok()
                .eTag(currentEtag)
                .body(response);
    }

}
