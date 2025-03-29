package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Getter
@Setter
@Document(collection = "meals")
public class Meal extends BaseEntity {
    private String name;
    private float calories;
    //Macro nutrients
    private float carbs;
    private float protein;
    private float fat;

    @DBRef
    private List<FoodItem> ingredients;
}
