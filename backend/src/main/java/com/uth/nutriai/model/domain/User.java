package com.uth.nutriai.model.domain;

import lombok.*;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.Document;

import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import com.uth.nutriai.model.enumeration.HealthGoal;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "users")
public class User extends BaseEntity {
    private String name;
    private String authProvider;
    private ActivityLevel activityLevel;
    private HealthGoal healthGoal;
    private int currentWeight;
    private int targetWeight;
    private int currentHeight;
}
