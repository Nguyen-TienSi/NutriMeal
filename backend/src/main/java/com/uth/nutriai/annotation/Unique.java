package com.uth.nutriai.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.*;

@Documented
@Constraint(validatedBy = UniqueValidator.class)
@Target({ElementType.FIELD})
@Retention(RetentionPolicy.RUNTIME)
public @interface Unique {
    String message() default "Field value must be unique";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Entity class to check against
     */
    Class<?> entity();

    /**
     * Field name in the entity to check
     */
    String fieldName();
}

