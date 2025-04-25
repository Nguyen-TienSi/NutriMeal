package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.MealLog;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface IMealLogRepository extends MongoRepository<MealLog, UUID> {
}
