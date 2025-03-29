package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Getter
@Setter
@Document(collection = "exercise_records")
public class ExerciseRecord extends BaseEntity {
    @DBRef
    private HealthTracking healthTracking;
    private LocalDate date;
    private String exerciseType;
    private float duration;
    private float caloriesBurned;
}
