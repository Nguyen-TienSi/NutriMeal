package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.Recipe;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.UUID;

public interface IRecipeDao extends IDao<Recipe, UUID> {

    List<Recipe> findByTimesOfDay(String mealTime);

    Page<Recipe> findByTimeOfDay(String mealTime, Pageable pageable);

    boolean existsByField(String field, Object value);

    List<Recipe> findByField(String field, Object value);
}
