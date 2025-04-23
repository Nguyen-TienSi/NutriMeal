package com.uth.nutriai.converter;

import com.uth.nutriai.model.enumeration.TimeOfDay;
import org.springframework.core.convert.converter.Converter;
import org.springframework.data.convert.ReadingConverter;

@ReadingConverter
public class TimeOfDayReadConverter implements Converter<String, TimeOfDay> {
    @Override
    public TimeOfDay convert(String source) {
        return TimeOfDay.valueOf(source.toUpperCase());
    }
}
