package com.uth.nutriai.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.http.ResponseEntity;

import com.uth.nutriai.service.UserService;

import java.util.List;
import java.util.Map;

@RestController
public class UserController {
    @Autowired
    private UserService userService;

    @GetMapping("api/user")
    public ResponseEntity<List<Map<String, Object>>> getAllUsers() {
        List<Map<String, Object>> users = userService.getAllUsers();
        return ResponseEntity.ok(users);
    }

    @GetMapping("api/user/{id}")
    public ResponseEntity<Map<String, Object>> getUserById(@PathVariable String id) {
        Map<String, Object> user = userService.findUserById(id);
        return ResponseEntity.ok(user);
    }
}
