package com.uth.nutriai.converter;

import com.mongodb.lang.NonNull;
import com.uth.nutriai.model.enumeration.HealthGoal;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

@ReadingConverter
public class HealthGoalReadConverter implements Converter<String, HealthGoal> {
    @Override
    public HealthGoal convert(@NonNull String source) {
        return HealthGoal.valueOf(source.toUpperCase());
    }
}
