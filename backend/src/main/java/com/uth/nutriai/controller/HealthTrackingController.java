package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.service.IHealthTrackingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Date;

@RestController
@RequestMapping(value = "/api/health-tracking", produces = "application/vnd.company.app-v1+json")
public class HealthTrackingController {

    @Autowired
    private IHealthTrackingService healthTrackingService;

    @GetMapping("/date")
    public ResponseEntity<ApiResponse<HealthTrackingDetailDto>> findHealthTrackingByDate(
            @RequestParam Date trackingDate,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {
        if(!healthTrackingService.isHealthTrackingAvailable(trackingDate)) {
            return ResponseEntity.notFound().build();
        }

        String currentEtag = healthTrackingService.currentEtag(trackingDate);

        if(eTag != null && eTag.equals(currentEtag)) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        HealthTrackingDetailDto healthTrackingDetailDto = healthTrackingService.findHealthTrackingByDate(trackingDate);

        ApiResponse<HealthTrackingDetailDto> response = new ApiResponse<>(healthTrackingDetailDto);
        return ResponseEntity.ok()
                .eTag(currentEtag)
                .body(response);
    }

}
