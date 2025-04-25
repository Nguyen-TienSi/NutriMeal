package com.uth.nutriai.converter;

import com.mongodb.lang.NonNull;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

@ReadingConverter
public class ActivityLevelReadConverter implements Converter<String, ActivityLevel> {
    @Override
    public ActivityLevel convert(@NonNull String source) {
        return ActivityLevel.valueOf(source.toUpperCase());
    }
}
