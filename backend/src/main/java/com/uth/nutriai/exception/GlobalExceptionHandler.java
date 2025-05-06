package com.uth.nutriai.exception;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.ValidationException;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ProblemDetail;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.HttpMediaTypeNotSupportedException;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.*;
import java.util.stream.Collectors;

@AllArgsConstructor
@RestControllerAdvice
public class GlobalExceptionHandler {

    private final ProblemDetailFactory problemDetailFactory;

    @ExceptionHandler(ResourceNotFoundException.class)
    public ProblemDetail handleResourceNotFoundException(ResourceNotFoundException ex,
                                                         HttpServletRequest request) {

        return problemDetailFactory
                .builder(ex.getStatusCode(), "Resource Not Found", ex.getMessage(), request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .build();
    }

    @ExceptionHandler(BusinessException.class)
    public ProblemDetail handleBusinessException(BusinessException ex, HttpServletRequest request) {
        return problemDetailFactory
                .builder(ex.getStatusCode(), "Business Rule Violation", ex.getMessage(), request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .build();
    }

    @ExceptionHandler(IllegalArgumentException.class)
    public ProblemDetail handleIllegalArgumentException(IllegalArgumentException ex,
                                                        HttpServletRequest request) {
        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Illegal Argument", ex.getMessage(), request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .build();
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleMethodArgumentNotValidException(
            MethodArgumentNotValidException ex, HttpServletRequest request) {

        Map<String, String> errors = new HashMap<>();

        ex.getBindingResult().getFieldErrors()
                .forEach(error -> errors.put(error.getField(), error.getDefaultMessage()));

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Validation Failed", "Input data is invalid.", request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .addProperty("errors", errors)
                .build();
    }

    @ExceptionHandler(UnsupportedOperationException.class)
    public ProblemDetail handleUnsupportedOperationException(
            UnsupportedOperationException ex, HttpServletRequest request) {

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Unsupported Operation", ex.getMessage(), request)
                .addProperty("exceptionType", ex.getClass().getName())
                .build();
    }

    @ExceptionHandler(ConstraintViolationException.class)
    public ProblemDetail handleConstraintViolationException(
            ConstraintViolationException ex, HttpServletRequest request) {

        Map<String, String> errors = new HashMap<>();

        Set<ConstraintViolation<?>> violations = ex.getConstraintViolations();
        for (ConstraintViolation<?> violation : violations) {
            String field = violation.getPropertyPath().toString();
            String message = violation.getMessage();
            errors.put(field, message);
        }

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Validation Failed", "Input data is invalid.", request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .addProperty("errors", errors)
                .build();
    }
    
    @ExceptionHandler(InvalidPatchException.class)
    public ProblemDetail handleInvalidPatchException(InvalidPatchException ex, HttpServletRequest request) {
        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Invalid Patch", ex.getMessage(), request)
                .addProperty("exceptionType", ex.getClass().getName())
                .build();
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ProblemDetail handleHttpMessageNotReadableException(HttpMessageNotReadableException ex,
                                                               HttpServletRequest request) {
        Map<String, String> error = new HashMap<>();
        error.put("error", "Malformed JSON request: " + ex.getMostSpecificCause().getMessage());

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Malformed JSON", "Request body is malformed.",
                        request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .addProperty("errors", error)
                .build();
    }

    @ExceptionHandler(ValidationException.class)
    public ProblemDetail handleValidationException(
            ValidationException ex, HttpServletRequest request) {

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Validation Failed", "Input data is invalid.", request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .build();
    }

    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ProblemDetail handleMissingServletRequestParameterException(
            MissingServletRequestParameterException ex, HttpServletRequest request) {

        Map<String, String> error = Map.of(
                ex.getParameterName(), "Missing required parameter of type: " + ex.getParameterType());

        return problemDetailFactory
                .builder(HttpStatus.BAD_REQUEST, "Missing Request Parameter", ex.getMessage(), request)
                .addProperty("exceptionType", ex.getClass().getName())
                .addProperty("errors", error)
                .build();
    }

    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    public ProblemDetail handleHttpRequestMethodNotSupported(
            HttpRequestMethodNotSupportedException ex, HttpServletRequest request) {

        String supportedMethods = String.join(", ", Objects.requireNonNull(ex.getSupportedMethods()));

        return problemDetailFactory
                .builder(HttpStatus.METHOD_NOT_ALLOWED, "Method Not Allowed", ex.getMessage(), request)
                .addProperty("exceptionType", ex.getClass().getName())
                .addProperty("supportedMethods", supportedMethods)
                .build();
    }

    @ExceptionHandler(HttpMediaTypeNotSupportedException.class)
    public ProblemDetail handleHttpMediaTypeNotSupported(
            HttpMediaTypeNotSupportedException ex, HttpServletRequest request) {

        String supported = ex.getSupportedMediaTypes().stream()
                .map(MediaType::toString)
                .collect(Collectors.joining(", "));

        return problemDetailFactory
                .builder(HttpStatus.UNSUPPORTED_MEDIA_TYPE, "Unsupported Media Type", ex.getMessage(),
                        request)
                .addProperty("exceptionType", ex.getClass().getName())
                .addProperty("supportedMediaTypes", supported)
                .build();
    }

    @ExceptionHandler(Exception.class)
    public ProblemDetail handleGenericException(Exception ex, HttpServletRequest request) {

        HttpStatus status = Optional
                .ofNullable(request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE))
                .map(Integer.class::cast)
                .map(HttpStatus::resolve)
                .orElse(HttpStatus.INTERNAL_SERVER_ERROR);

        return problemDetailFactory
                .builder(status, status.getReasonPhrase(), ex.getMessage(), request)
                // .addProperty("cause", ex.getCause().getMessage())
                .addProperty("exceptionType", ex.getClass().getName())
                // .addProperty("stackTrace", Arrays.toString(ex.getStackTrace()))
                .build();
    }
}
