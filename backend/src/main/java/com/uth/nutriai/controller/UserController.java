package com.uth.nutriai.controller;

import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.service.IUserService;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "api/users", produces = "application/vnd.company.app-v1+json")
@AllArgsConstructor
public class UserController {

    private IUserService userService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<UserDetailDto>>> findAllUsers() {
        List<UserDetailDto> userDetailDtoList = userService.findAllUsers();
        if (userDetailDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<UserDetailDto>> response = new ApiResponse<>(userDetailDtoList);
        return ResponseEntity.ok(response);
    }

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<UserDetailDto>> findUserById(@RequestParam UUID id) {
        UserDetailDto userDetailDto = userService.findUserById(id);
        if (userDetailDto == null) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<UserDetailDto> response = new ApiResponse<>(userDetailDto);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<UserDetailDto>> createUser(@Valid @RequestBody UserCreateDto userCreateDto) {
        UserDetailDto createdUser = userService.createUser(userCreateDto);
        URI location = URI.create("/api/users/" + createdUser.id());
        ApiResponse<UserDetailDto> response = new ApiResponse<>(createdUser);
        return ResponseEntity.created(location).body(response);
    }

    @PutMapping
    public ResponseEntity<Void> updateUser() {
        return ResponseEntity.status(HttpStatus.NOT_IMPLEMENTED).build();
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteUser(@RequestParam UUID id) {
        userService.deleteUser(id);
        return ResponseEntity.noContent().build();
    }
}
