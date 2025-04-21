package com.uth.nutriai.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(value = "/api", produces = "application/vnd.company.app-v1+json")
public class HealthController {

    @RequestMapping(value = "/health", method = RequestMethod.HEAD)
    public ResponseEntity<Void> checkHealth() {
        return ResponseEntity.noContent().build();
    }
}
