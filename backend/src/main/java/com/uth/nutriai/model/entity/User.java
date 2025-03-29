package com.uth.nutriai.model.entity;

import com.uth.nutriai.model.enumuration.ActivityLevel;
import com.uth.nutriai.model.enumuration.Goal;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.DocumentReference;

import java.util.List;

@Getter
@Setter
@Document(collection = "users")
public class User extends BaseEntity {
    private int age;
    private float weight;
    private float height;
    private ActivityLevel activityLevel;
    private Goal goal;

    @DocumentReference(lazy = true)
    private List<DietPreference> dietPreferences;
}
