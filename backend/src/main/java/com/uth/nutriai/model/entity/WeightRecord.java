package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDate;

@Getter
@Setter
@Document(collection = "weight_records")
public class WeightRecord extends BaseEntity {
    @DBRef
    private HealthTracking healthTracking;
    private LocalDate date;
    private float weight;
}
