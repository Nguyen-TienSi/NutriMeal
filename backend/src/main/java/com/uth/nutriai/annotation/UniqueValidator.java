package com.uth.nutriai.annotation;

import com.uth.nutriai.service.UniqueValueService;
import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;
import org.springframework.stereotype.Component;

@Component
public class UniqueValidator implements ConstraintValidator<Unique, Object> {

    private final UniqueValueService uniqueValueService;

    private Class<?> entityClass;
    private String fieldName;

    public UniqueValidator(UniqueValueService uniqueValueService) {
        this.uniqueValueService = uniqueValueService;
    }

    @Override
    public void initialize(Unique constraintAnnotation) {
        this.entityClass = constraintAnnotation.entity();
        this.fieldName = constraintAnnotation.fieldName();
    }

    @Override
    public boolean isValid(Object value, ConstraintValidatorContext context) {
        if (value == null) return true;
        return uniqueValueService.isUnique(entityClass, fieldName, value);
    }
}
