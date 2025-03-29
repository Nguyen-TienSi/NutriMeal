package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@Getter
@Setter
@Document(collection = "food_items")
public class FoodItem extends BaseEntity {
    private String name;
    private float calories;

    @DBRef
    private List<Nutrient> nutrients;
}
