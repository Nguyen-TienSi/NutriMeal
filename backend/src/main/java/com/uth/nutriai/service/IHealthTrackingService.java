package com.uth.nutriai.service;

import com.uth.nutriai.dto.response.HealthTrackingDetailDto;

import java.util.Date;

public interface IHealthTrackingService {

    boolean isHealthTrackingAvailable(Date trackingDate);

    HealthTrackingDetailDto findHealthTrackingByDate(Date trackingDate);

    String currentEtag(Date trackingDate);
}
