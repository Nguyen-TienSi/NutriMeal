package com.uth.nutriai.converter;

import com.mongodb.lang.NonNull;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

import java.time.Duration;

@ReadingConverter
public class LongToDurationReadConverter implements Converter<Long, Duration> {
    @Override
    public Duration convert(@NonNull Long source) {
        return Duration.ofMinutes(source);
    }
}
