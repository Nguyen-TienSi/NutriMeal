package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Getter
@Setter
@Document(collection = "diet_preferences")
public class DietPreference extends BaseEntity {
    private String name;
    private String description;

    @DBRef
    private List<Nutrient> restrictedNutrients;
    @DBRef
    private List<FoodItem> restrictedFoodItems;
}
