package com.uth.nutriai.model.domain;

import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Date;
import java.util.List;
import java.util.Map;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "meals")
public class MealLog extends BaseEntity {

    @DBRef
    private User user;

    @DBRef
    private List<Recipe> recipeList;

    private TimeOfDay timeOfDay;

    private Date mealDate;

    private double totalCalories;

    private List<Map<Nutrient, Double>> consumedNutrients;
}
