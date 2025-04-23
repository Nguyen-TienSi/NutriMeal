package com.uth.nutriai.annotation;

import com.uth.nutriai.dto.shared.TimeOfDayDto;
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
@Constraint(validatedBy = AllowedTimeOfDayValidator.class)
public @interface AllowedTimeOfDay {
    String message() default "Invalid time of day";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};

    TimeOfDayDto[] anyOf(); // cho phép nhiều giá trị enum
}
