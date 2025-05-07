package com.uth.nutriai.model.domain;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Builder
@AllArgsConstructor
public class Nutrient {
    private String name;
    private String unit;
    private double value;
}
