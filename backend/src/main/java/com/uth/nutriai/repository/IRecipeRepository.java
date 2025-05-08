package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import org.springframework.data.domain.Page;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;
import org.springframework.data.domain.Pageable;

@Repository
public interface IRecipeRepository extends MongoRepository<Recipe, UUID> {

    Page<Recipe> findByTimesOfDayIsLike(List<TimeOfDay> timesOfDay, Pageable pageable);

    List<Recipe> findByTimesOfDayIsLike(List<TimeOfDay> timesOfDay);
}
