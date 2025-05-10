package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.User;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface IHealthTrackingDao extends IDao<HealthTracking, UUID> {

    Optional<HealthTracking> findByTrackingDateAndUser(Date trackingDate, User user);

    List<HealthTracking> findAllByUser(User user);

    List<HealthTracking> findByUserAndTrackingDateBetween(User user, Date startDate, Date endDate);
}
