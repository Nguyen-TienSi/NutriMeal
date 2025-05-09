package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.StreakDetailDto;
import com.uth.nutriai.service.IStreakService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api/streaks", produces = "application/vnd.company.app-v1+json")
public class StreakController {

    @Autowired
    private IStreakService streakService;

    @GetMapping
    public ResponseEntity<ApiResponse<StreakDetailDto>> findStreakByUser() {
        StreakDetailDto streakDetailDto = streakService.findStreak();
        if (streakDetailDto == null) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<StreakDetailDto> response = new ApiResponse<>(streakDetailDto);
        return ResponseEntity.ok(response);
    }
}
