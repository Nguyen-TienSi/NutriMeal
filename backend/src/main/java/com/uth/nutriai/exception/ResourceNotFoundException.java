package com.uth.nutriai.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.NOT_FOUND)
@Getter
@Setter
public class ResourceNotFoundException extends RuntimeException {

    private HttpStatus statusCode;

    public ResourceNotFoundException(String message) {
        super(message);
    }

    public ResourceNotFoundException(String message, HttpStatus statusCode) {
        super(message);
        this.statusCode = statusCode;
    }
}
