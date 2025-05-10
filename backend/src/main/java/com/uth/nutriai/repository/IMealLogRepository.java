package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Repository
public interface IMealLogRepository extends MongoRepository<MealLog, UUID> {

    List<MealLog> findByTrackingDateAndUser(Date trackingDate, User user);

    List<MealLog> findAllByUser(User user);
}
