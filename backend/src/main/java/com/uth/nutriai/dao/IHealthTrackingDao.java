package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.User;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;

public interface IHealthTrackingDao extends IDao<HealthTracking, UUID> {

    Optional<HealthTracking> findByTrackingDateAndUser(Date trackingDate, User user);
}
