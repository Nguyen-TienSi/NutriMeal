package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.service.IHealthTrackingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping(value = "/api/health-tracking", produces = "application/vnd.company.app-v1+json")
public class HealthTrackingController {

    @Autowired
    private IHealthTrackingService healthTrackingService;

    @GetMapping("/{date}")
    public ResponseEntity<ApiResponse<HealthTrackingDetailDto>> findHealthTrackingByDate(
            @PathVariable("date") @DateTimeFormat(pattern = "yyyy-MM-dd") Date trackingDate,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {
        if (eTag != null && eTag.equals(healthTrackingService.currentEtag(trackingDate))) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        HealthTrackingDetailDto healthTrackingDetailDto = healthTrackingService.findHealthTrackingByDate(trackingDate);

        if (healthTrackingDetailDto == null) {
            return ResponseEntity.noContent().build();
        }

        return ResponseEntity.ok()
                .eTag(healthTrackingService.currentEtag(trackingDate))
                .body(new ApiResponse<>(healthTrackingDetailDto));
    }

}
