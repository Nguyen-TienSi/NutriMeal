package com.uth.nutriai.converter;

import com.mongodb.lang.NonNull;
import com.uth.nutriai.model.enumeration.HealthGoal;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.WritingConverter;

@WritingConverter
public class HealthGoalWriteConverter implements Converter<HealthGoal, String> {
    @Override
    public String convert(@NonNull HealthGoal source) {
        return source.name().toLowerCase();
    }
}
