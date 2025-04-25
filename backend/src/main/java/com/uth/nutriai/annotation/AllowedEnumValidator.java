package com.uth.nutriai.annotation;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

public class AllowedEnumValidator implements ConstraintValidator<AllowedEnum, Enum<?>> {

    private final Set<String> allowedValues = new HashSet<>();

    @Override
    public void initialize(AllowedEnum constraintAnnotation) {
        allowedValues.addAll(Arrays.asList(constraintAnnotation.allowed()));
    }

    @Override
    public boolean isValid(Enum<?> value, ConstraintValidatorContext context) {
        if (value == null) return true;
        return allowedValues.contains(value.name());
    }
}
