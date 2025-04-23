package com.uth.nutriai.model.domain;

import java.time.Duration;
import java.util.List;

import com.uth.nutriai.model.enumeration.TimeOfDay;
import lombok.*;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.Document;

import com.uth.nutriai.model.BaseEntity;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "recipes")
public class Recipe extends BaseEntity {
    private String recipeName;
    private String description;
    private String instructions;
    private String imageUrl;
    private Duration cookingTime;
    private float serving;
    private String servingUnit;
    private List<Ingredient> ingredients;
    private List<FoodTag> foodTags;
    private List<Nutrient> nutrients;
    private List<TimeOfDay> timesOfDay;
}
