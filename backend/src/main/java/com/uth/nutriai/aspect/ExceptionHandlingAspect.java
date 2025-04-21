package com.uth.nutriai.aspect;

import lombok.extern.slf4j.Slf4j;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Aspect;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Component;

import com.uth.nutriai.exception.*;

import java.util.HashMap;
import java.util.Map;
import java.util.function.Function;

@Aspect
@Component
@Slf4j
public class ExceptionHandlingAspect {

    private final Map<Class<? extends Throwable>, Function<Throwable, RuntimeException>> exceptionHandlers;

    public ExceptionHandlingAspect() {
        exceptionHandlers = new HashMap<>();
        exceptionHandlers.put(BusinessException.class,
                ex -> new BusinessException(ex.getMessage(), HttpStatus.BAD_REQUEST));
        exceptionHandlers.put(ResourceNotFoundException.class,
                ex -> new ResourceNotFoundException(ex.getMessage(), HttpStatus.NOT_FOUND));
    }

    @AfterThrowing(pointcut = "execution(* com.uth.nutriai.service.*.*(..)) || execution(* com.uth.nutriai.controller.*.*(..)) || execution(* com.uth.nutriai.dao.*.*(..))", throwing = "ex")
    public void handleException(JoinPoint joinPoint, Throwable ex) {
        Class<?> exceptionClass = ex.getClass();

        if (exceptionHandlers.containsKey(exceptionClass)) {
            System.out.println("Caught " + exceptionClass.getSimpleName() + ": " + ex.getMessage());
            // log.warn("Caught {}: {}", exceptionClass.getSimpleName(), ex.getMessage());
            throw exceptionHandlers.get(exceptionClass).apply(ex);
        } else {
            log.error("Unhandled exception in {}.{}: {}",
                    joinPoint.getSignature().getDeclaringTypeName(),
                    joinPoint.getSignature().getName(),
                    ex.getMessage(), ex);

            throw new RuntimeException(ex.getMessage());
        }
    }
}
