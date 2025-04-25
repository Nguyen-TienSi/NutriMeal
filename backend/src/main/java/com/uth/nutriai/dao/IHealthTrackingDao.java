package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.HealthTracking;

import java.util.Date;
import java.util.UUID;

public interface IHealthTrackingDao extends IDao<HealthTracking, UUID> {

    boolean existsByDate(Date date);

    HealthTracking findHealthTrackingByDate(Date date);
}
