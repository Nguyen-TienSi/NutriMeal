package com.uth.nutriai.exception;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.Optional;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.stereotype.Component;

import jakarta.servlet.http.HttpServletRequest;

@Component
public class ProblemDetailFactory {

    public ProblemDetailBuilder builder(HttpStatus status, String title, String detail, HttpServletRequest request) {
        return new ProblemDetailBuilder(status, title, detail, request);
    }

    public static class ProblemDetailBuilder {
        private final ProblemDetail problemDetail;

        public ProblemDetailBuilder(HttpStatus status, String title, String detail, HttpServletRequest request) {
            problemDetail = ProblemDetail.forStatusAndDetail(status, detail);
            problemDetail.setTitle(title);
            problemDetail.setInstance(URI.create(request.getRequestURI()));
            problemDetail.setProperty("timestamp", LocalDateTime.now());
            problemDetail.setProperty("path", request.getRequestURI());
            problemDetail.setProperty("traceId", Optional.ofNullable(request.getHeader("X-Trace-Id"))
                    .orElse(UUID.randomUUID().toString()));
        }

        public ProblemDetailBuilder addProperty(String key, Object value) {
            problemDetail.setProperty(key, value);
            return this;
        }

        public ProblemDetail build() {
            return problemDetail;
        }
    }
}
