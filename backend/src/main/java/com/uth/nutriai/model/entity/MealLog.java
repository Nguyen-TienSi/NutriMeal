package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Getter
@Setter
@Document(collection = "meal_logs")
public class MealLog extends BaseEntity {
    @DBRef
    private User user;
    @DBRef
    private Meal meal;
    @DBRef
    private HealthTracking healthTracking;
    private LocalDateTime loggedAt = LocalDateTime.now();
}
