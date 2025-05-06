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
    @Unique(entity = MealLog.class, fieldName = "recipeList", message = "Recipe list cannot contain duplicates")
    private List<Recipe> recipeList;

    private TimeOfDay timeOfDay;

    private Date trackingDate;

    private double totalCalories;

    @Unique(entity = MealLog.class, fieldName = "consumedNutrients", message = "Nutrient already exists")
    private List<Nutrient> consumedNutrients;
}
