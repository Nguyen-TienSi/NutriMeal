package com.uth.nutriai.dao.impl;


import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.repository.IHealthTrackingRepository;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Optional;
import java.util.UUID;

@Component
public class HealthTrackingDaoImpl extends GenericDaoImpl<HealthTracking, UUID> implements IHealthTrackingDao {
    public HealthTrackingDaoImpl(IHealthTrackingRepository repository) {
        super(repository);
    }

    @Override
    public Optional<HealthTracking> findByTrackingDateAndUser(Date trackingDate, User user) {
        return ((IHealthTrackingRepository) repository).findByTrackingDateAndUser(trackingDate, user);
    }
}
