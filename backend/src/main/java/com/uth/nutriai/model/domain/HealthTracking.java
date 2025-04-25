package com.uth.nutriai.model.domain;

import com.uth.nutriai.model.BaseEntity;
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
@Document(collection = "health_tracking")
public class HealthTracking extends BaseEntity {

    @DBRef
    private User user;

    private Date trackingDate;

    private double totalCalories;

    private List<Map<Nutrient, Double>> consumedNutrients;
}
