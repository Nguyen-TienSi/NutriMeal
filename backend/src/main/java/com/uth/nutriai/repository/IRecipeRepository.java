package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface IRecipeRepository extends MongoRepository<Recipe, UUID> {

    List<Recipe> findByTimesOfDayIsLike(List<TimeOfDay> timesOfDay);
}
