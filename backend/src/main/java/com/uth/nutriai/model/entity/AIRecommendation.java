package com.uth.nutriai.model.entity;

import lombok.Getter;
import lombok.Setter;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

@Getter
@Setter
@Document(collection = "ai_recommendations")
public class AIRecommendation extends BaseEntity {
    @DBRef
    private User user;

    private LocalDateTime generatedAt = LocalDateTime.now();
}
