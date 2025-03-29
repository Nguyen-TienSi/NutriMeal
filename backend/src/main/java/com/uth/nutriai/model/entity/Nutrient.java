package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.Document;

@Getter
@Setter
@Document(collection = "nutrients")
public class Nutrient extends BaseEntity {
    private String name;
    private String unit;
    private float dailyValue;
}
