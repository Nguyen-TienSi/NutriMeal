package com.uth.nutriai.utils;

import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.domain.Nutrient;

import java.util.List;
import java.util.Map;

public interface INutritionCalculator<T extends BaseEntity> {

    default double calculateCalories(T entity) {
        return calculateFromNutrients(getConsumedNutrients(entity));
    }

    private double calculateFromNutrients(List<Map<Nutrient, Double>> consumedNutrients) {
        double protein = 0;
        double carbs = 0;
        double fat = 0;

        for (Map<Nutrient, Double> consumed : consumedNutrients) {
            for (Map.Entry<Nutrient, Double> entry : consumed.entrySet()) {
                String name = entry.getKey().getName().toLowerCase();
                double value = entry.getValue();

                switch (name) {
                    case "protein" -> protein += value;
                    case "carbohydrates", "carbs" -> carbs += value;
                    case "fat" -> fat += value;
                }
            }
        }

        // 1g protein = 4 kcal, 1g carb = 4 kcal, 1g fat = 9 kcal
        return (protein * 4) + (carbs * 4) + (fat * 9);
    }

    List<Map<Nutrient, Double>> getConsumedNutrients(T entity);
}
