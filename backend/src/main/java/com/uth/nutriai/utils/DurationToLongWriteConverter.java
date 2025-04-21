package com.uth.nutriai.utils;

import com.mongodb.lang.NonNull;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.WritingConverter;

import java.time.Duration;

@WritingConverter
public class DurationToLongWriteConverter implements Converter<Duration, Long> {
    @Override
    public Long convert(@NonNull Duration source) {
        return source.toMillis();
    }
}
