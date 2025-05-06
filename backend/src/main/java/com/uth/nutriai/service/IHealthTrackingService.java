package com.uth.nutriai.service;

import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.model.domain.MealLog;

import java.util.Date;
import java.util.UUID;

public interface IHealthTrackingService {

    HealthTrackingDetailDto findHealthTrackingByDate(Date trackingDate);

    String currentEtag(Date trackingDate);
}
