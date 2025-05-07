package com.uth.nutriai.model.domain;

import com.uth.nutriai.annotation.Unique;
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

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "meal-logs")
public class MealLog extends BaseEntity {

    @DBRef
    private User user;

    @DBRef
    private List<Recipe> recipeList;

    private TimeOfDay timeOfDay;

    private Date trackingDate;

    private double totalCalories;

    private List<Nutrient> consumedNutrients;

    private List<Nutrient> totalNutrients;
}
