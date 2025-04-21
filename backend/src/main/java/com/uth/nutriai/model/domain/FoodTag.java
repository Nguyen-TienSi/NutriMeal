package com.uth.nutriai.model.domain;

import lombok.*;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@Builder
public class FoodTag {
    private String name;
}
