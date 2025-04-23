package com.uth.nutriai.converter;

import com.uth.nutriai.model.enumeration.TimeOfDay;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.WritingConverter;

@WritingConverter
public class TimeOfDayWriteConverter implements Converter<TimeOfDay, String> {
    @Override
    public String convert(TimeOfDay source) {
        return source.name().toLowerCase();
    }
}
