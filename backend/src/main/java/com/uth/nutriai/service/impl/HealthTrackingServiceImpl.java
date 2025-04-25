package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.mapper.IHealthTrackingMapper;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.service.IHealthTrackingService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;

@AllArgsConstructor
@Service
public class HealthTrackingServiceImpl implements IHealthTrackingService {

    private IHealthTrackingDao healthTrackingDao;
    private IHealthTrackingMapper healthTrackingMapper;

    @Override
    public boolean isHealthTrackingAvailable(Date trackingDate) {
        return healthTrackingDao.existsByDate(trackingDate);
    }

    @Override
    public HealthTrackingDetailDto findHealthTrackingByDate(Date trackingDate) {
        HealthTracking healthTracking = healthTrackingDao.findHealthTrackingByDate(trackingDate);
        return healthTrackingMapper.mapToHealthTrackingDetailDto(healthTracking);
    }

    @Override
    public String currentEtag(Date trackingDate) {
        HealthTracking healthTracking = healthTrackingDao.findHealthTrackingByDate(trackingDate);
        return EtagUtil.generateEtag(healthTracking);
    }
}
