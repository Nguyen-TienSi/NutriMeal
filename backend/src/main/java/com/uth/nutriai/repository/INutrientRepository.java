package com.uth.nutriai.repository;

import com.uth.nutriai.model.entity.Nutrient;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface INutrientRepository extends MongoRepository<Nutrient, UUID> {
}
