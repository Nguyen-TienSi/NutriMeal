package com.uth.nutriai.model.domain;

import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
public class Ingredient {
    private String name;
    private double quantity;
    private String unit;
}
