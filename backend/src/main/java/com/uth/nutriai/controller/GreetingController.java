package com.uth.nutriai.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/greeting")
public class GreetingController {

    private final Logger logger = LoggerFactory.getLogger(GreetingController.class);

    @GetMapping("/get-hello")
    public String sayHello() {
        logger.info("hello");

        return "Hello World";
    }
}
