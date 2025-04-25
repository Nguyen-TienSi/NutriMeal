package com.uth.nutriai.converter;

import com.mongodb.lang.NonNull;
import com.uth.nutriai.model.enumeration.ActivityLevel;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.WritingConverter;

@WritingConverter
public class ActivityLevelWriteConverter implements Converter<ActivityLevel, String> {
    @Override
    public String convert(@NonNull ActivityLevel source) {
        return source.name().toLowerCase();
    }
}
