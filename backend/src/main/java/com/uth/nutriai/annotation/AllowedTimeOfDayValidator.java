package com.uth.nutriai.annotation;

import com.uth.nutriai.dto.shared.TimeOfDayDto;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Arrays;
import java.util.List;

public class AllowedTimeOfDayValidator implements ConstraintValidator<AllowedTimeOfDay, TimeOfDayDto> {

    private List<TimeOfDayDto> allowedValues;

    @Override
    public void initialize(AllowedTimeOfDay constraintAnnotation) {
        allowedValues = Arrays.asList(constraintAnnotation.anyOf());
    }

    @Override
    public boolean isValid(TimeOfDayDto timeOfDayDto, ConstraintValidatorContext constraintValidatorContext) {
        if (timeOfDayDto == null) return true;
        return  allowedValues.contains(timeOfDayDto);
    }
}
