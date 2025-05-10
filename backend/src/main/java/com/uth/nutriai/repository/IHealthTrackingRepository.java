package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface IHealthTrackingRepository extends MongoRepository<HealthTracking, UUID> {

    Optional<HealthTracking> findByTrackingDateAndUser(Date trackingDate, User user);

    List<HealthTracking> findAllByUser(User user);

    List<HealthTracking> findByUserAndTrackingDateBetween(User user, Date startDate, Date endDate);
}
