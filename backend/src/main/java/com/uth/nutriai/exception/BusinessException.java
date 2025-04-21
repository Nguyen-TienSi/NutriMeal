package com.uth.nutriai.exception;

import lombok.Getter;
import lombok.Setter;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(HttpStatus.BAD_REQUEST)
@Getter
@Setter
public class BusinessException extends RuntimeException {

    private HttpStatus statusCode;

    public BusinessException(String message) {
        super(message);
    }

    public BusinessException(String message, HttpStatus statusCode) {
        super(message);
        this.statusCode = statusCode;
    }
}
