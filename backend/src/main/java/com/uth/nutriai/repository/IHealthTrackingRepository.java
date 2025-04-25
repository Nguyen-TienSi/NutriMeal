package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.HealthTracking;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.UUID;

@Repository
public interface IHealthTrackingRepository extends MongoRepository<HealthTracking, UUID> {

    boolean existsHealthTrackingByTrackingDate(Date date);

    HealthTracking findHealthTrackingByTrackingDate(Date date);
}
