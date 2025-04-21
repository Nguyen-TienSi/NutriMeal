package com.uth.nutriai.exception;

import java.net.URI;
import java.time.LocalDateTime;
import java.util.UUID;
import java.util.stream.Collectors;
import java.util.Collections;
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
            long requestStartTime = System.currentTimeMillis();
            problemDetail = ProblemDetail.forStatusAndDetail(status, detail);
            problemDetail.setTitle(title);
            problemDetail.setInstance(URI.create(request.getRequestURI()));
            problemDetail.setProperty("timestamp", LocalDateTime.now());
            problemDetail.setProperty("path", request.getRequestURI());
            problemDetail.setProperty("method", request.getMethod());
            problemDetail.setProperty("queryParams", request.getQueryString());
            problemDetail.setProperty("traceId", Optional.ofNullable(request.getHeader("X-Trace-Id"))
                    .orElse(UUID.randomUUID().toString()));
            problemDetail.setProperty("ipAddress", request.getRemoteAddr());
            problemDetail.setProperty("user", request.getRemoteUser());
            problemDetail.setProperty("contentType", request.getContentType());
            problemDetail.setProperty("authenticationType", request.getAuthType());
            problemDetail.setProperty("serverPort", request.getServerPort());
            problemDetail.setProperty("serverName", request.getServerName());
            // Optional.ofNullable(request.getSession(false))
            // .ifPresentOrElse(
            // session -> problemDetail.setProperty("sessionId", session.getId()),
            // () -> problemDetail.setProperty("sessionId", null));
            // problemDetail.setProperty("sessionId", request.getSession(false).getId());
            // problemDetail.setProperty("cookies", Arrays.toString(request.getCookies()));
            problemDetail.setProperty("responseTime", System.currentTimeMillis() -
                    requestStartTime);
            problemDetail.setProperty("headers", Collections.list(request.getHeaderNames())
                    .stream()
                    .collect(Collectors.toMap(name -> name, request::getHeader)));
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
