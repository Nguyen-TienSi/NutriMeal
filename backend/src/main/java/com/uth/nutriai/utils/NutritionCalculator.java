package com.uth.nutriai.utils;

public interface NutritionCalculator {
    default double calculateNutrients() {
        return 0L;
    }
}
