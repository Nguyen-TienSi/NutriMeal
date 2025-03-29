package com.uth.nutriai.model.entity;

import com.uth.nutriai.model.enumuration.MealPlanStatus;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;
import java.util.List;

@Getter
@Setter
@Document(collection = "meal_plans")
public class MealPlan extends BaseEntity {
    @DBRef
    private User user;

    private LocalDate startDate;
    private LocalDate endDate;
    private MealPlanStatus status;

    @DBRef
    private List<Meal> meals;
}
