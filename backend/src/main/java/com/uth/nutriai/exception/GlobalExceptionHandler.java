package com.uth.nutriai.exception;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.http.HttpServletRequest;
import lombok.AllArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;

import java.util.List;
import java.util.Optional;

@AllArgsConstructor
@RestControllerAdvice
public class GlobalExceptionHandler {

        private final ProblemDetailFactory problemDetailFactory;

        @ExceptionHandler(ResourceNotFoundException.class)
        public ResponseEntity<ProblemDetail> handleResourceNotFoundException(
                        ResourceNotFoundException ex, HttpServletRequest request) {

                ProblemDetail problemDetail = problemDetailFactory
                                .builder(HttpStatus.NOT_FOUND, "Resource Not Found", ex.getMessage(), request)
                                .build();
                return ResponseEntity.status(HttpStatus.NOT_FOUND).body(problemDetail);
        }

        @ExceptionHandler(MethodArgumentNotValidException.class)
        public ResponseEntity<ProblemDetail> handleValidationException(
                        MethodArgumentNotValidException ex, HttpServletRequest request) {

                List<String> details = ex.getBindingResult().getFieldErrors().stream()
                                .map(error -> error.getField() + ": " + error.getDefaultMessage())
                                .toList();

                ProblemDetail problemDetail = problemDetailFactory
                                .builder(HttpStatus.BAD_REQUEST, "Validation Failed", "Input data is invalid.", request)
                                .addProperty("details", details)
                                .build();

                return ResponseEntity.badRequest().body(problemDetail);
        }

        @ExceptionHandler(Exception.class)
        public ResponseEntity<ProblemDetail> handleGenericException(Exception ex, HttpServletRequest request) {
                HttpStatus status = Optional
                                .ofNullable(request.getAttribute(RequestDispatcher.ERROR_STATUS_CODE))
                                .map(Integer.class::cast)
                                .map(HttpStatus::resolve)
                                .orElse(HttpStatus.INTERNAL_SERVER_ERROR);
                ProblemDetail problemDetail = problemDetailFactory
                                .builder(status, status.getReasonPhrase(), ex.getMessage(), request)
                                .build();
                return ResponseEntity.internalServerError().body(problemDetail);
        }
}
