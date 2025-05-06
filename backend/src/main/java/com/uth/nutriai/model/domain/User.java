package com.uth.nutriai.model.domain;

import lombok.*;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.Document;

import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import com.uth.nutriai.model.enumeration.HealthGoal;

import java.util.Date;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "users")
public class User extends BaseEntity {
    private String userId;
    private String name;
    private String email;
    private String pictureUrl;
    private String authProvider;
    private String gender;
    private Date dateOfBirth;
    private ActivityLevel activityLevel;
    private HealthGoal healthGoal;
    private int currentWeight;
    private int targetWeight;
    private int currentHeight;
}
