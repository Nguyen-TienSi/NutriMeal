package com.uth.nutriai.repository;

import org.springframework.stereotype.Repository;
import org.springframework.data.mongodb.repository.MongoRepository;

import com.uth.nutriai.model.domain.Recipe;

import java.util.UUID;

@Repository
public interface IRecipeRepository extends MongoRepository<Recipe, UUID> {
}
