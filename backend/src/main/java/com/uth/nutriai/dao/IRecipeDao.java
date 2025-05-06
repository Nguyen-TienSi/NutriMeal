package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.Recipe;

import java.util.List;
import java.util.UUID;

public interface IRecipeDao extends IDao<Recipe, UUID> {

    List<Recipe> findByTimeOfDay(String mealTime);

    boolean existsByField(String field, Object value);

    List<Recipe> findByField(String field, Object value);
}
