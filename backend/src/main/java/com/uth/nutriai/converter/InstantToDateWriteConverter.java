package com.uth.nutriai.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.WritingConverter;
import org.springframework.lang.NonNull;

import java.time.Instant;
import java.util.Date;

@WritingConverter
public class InstantToDateWriteConverter implements Converter<Instant, Date> {
    @Override
    public Date convert(@NonNull Instant source) {
        return Date.from(source);
    }
}
