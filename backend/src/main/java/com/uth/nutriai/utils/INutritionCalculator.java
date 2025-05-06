package com.uth.nutriai.utils;

import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.domain.Nutrient;

import java.util.List;
import java.util.Map;

public interface INutritionCalculator<T extends BaseEntity> {

    default double calculateCalories(T entity) {
        return calculateFromNutrients(getConsumedNutrients(entity));
    }

    private double calculateFromNutrients(List<Nutrient> consumedNutrients) {
        double protein = 0;
        double carbs = 0;
        double fat = 0;

        for (Nutrient nutrient : consumedNutrients) {
            String name = nutrient.getName().toLowerCase();
            switch (name) {
                case "protein" -> protein = nutrient.getValue();
                case "carbohydrates", "carbs" -> carbs = nutrient.getValue();
                case "fat" -> fat = nutrient.getValue();
            }
        }

        return protein * 4 + carbs * 4 + fat * 9;
    }

    List<Nutrient> getConsumedNutrients(T entity);
}
