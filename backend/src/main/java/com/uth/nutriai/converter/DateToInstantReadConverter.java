package com.uth.nutriai.converter;

import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

import java.time.Instant;
import java.util.Date;

@ReadingConverter
public class DateToInstantReadConverter implements Converter<Date, Instant> {
    @Override
    public Instant convert(Date source) {
        return source.toInstant();
    }
}
