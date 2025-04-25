package com.uth.nutriai.annotation;

import jakarta.validation.Constraint;
import jakarta.validation.Payload;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

@Target({
        ElementType.FIELD,
        ElementType.METHOD,
        ElementType.PARAMETER,
        ElementType.ANNOTATION_TYPE,
        ElementType.TYPE_USE
})
@Retention(RetentionPolicy.RUNTIME)
@Constraint(validatedBy = AllowedEnumValidator.class)
public @interface AllowedEnum {

    String message() default "Value is not allowed";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    /**
     * Enum class (must implement `Enum`)
     */
    Class<? extends Enum<?>> enumClass();

    /**
     * Enum values allowed
     */
    String[] allowed();
}
