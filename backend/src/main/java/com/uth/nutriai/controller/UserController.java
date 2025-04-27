package com.uth.nutriai.controller;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.security.GoogleTokenVerifier;
import com.uth.nutriai.service.IUserService;
import jakarta.validation.Valid;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/users", produces = "application/vnd.company.app-v1+json")
public class UserController {

    @Autowired
    private IUserService userService;

    @Autowired
    private GoogleTokenVerifier googleTokenVerifier;

    @GetMapping
    public ResponseEntity<ApiResponse<List<UserDetailDto>>> findAllUsers() {
        List<UserDetailDto> userDetailDtoList = userService.findAllUsers();
        if (userDetailDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<UserDetailDto>> response = new ApiResponse<>(userDetailDtoList);
        return ResponseEntity.ok(response);
    }

    @RequestMapping(value = "/search", method = {RequestMethod.GET, RequestMethod.HEAD})
    public ResponseEntity<ApiResponse<UserDetailDto>> findUserById(
            @RequestParam String email,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {
        if (!userService.isUserAvailable(email)) {
            return ResponseEntity.notFound().build();
        }

        String currentEtag = userService.currentEtag(email);

        if (eTag != null && eTag.equals(currentEtag)) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        UserDetailDto userDetailDto = userService.findUserByEmail(email);

        ApiResponse<UserDetailDto> response = new ApiResponse<>(userDetailDto);
        return ResponseEntity.ok()
                .eTag(currentEtag)
                .body(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<UserDetailDto>> createUser(
            @RequestHeader("Authorization") String authHeader,
            @Valid @RequestBody UserCreateDto userCreateDto) {

        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }

        String idToken = authHeader.substring(7);
        GoogleIdToken.Payload userPayload = googleTokenVerifier.verify(idToken);

        String subject = userPayload.getSubject();
        String email = userPayload.getEmail();
        String name = (String) userPayload.get("name");
        String pictureUrl = (String) userPayload.get("picture");
        String authProvider = (String) userPayload.get("iss");

        UserCreateDto userToCreate = new UserCreateDto(
                subject,
                name,
                email,
                pictureUrl,
                authProvider,
                userCreateDto.activityLevelDto(),
                userCreateDto.healthGoalDto(),
                userCreateDto.currentWeight(),
                userCreateDto.targetWeight(),
                userCreateDto.currentHeight()
        );

        UserDetailDto createdUser = userService.createUser(userToCreate);
        URI location = URI.create("/api/users/search?email=" + createdUser.email());
        String currentEtag = userService.currentEtag(createdUser.email());
        ApiResponse<UserDetailDto> response = new ApiResponse<>(createdUser);
        return ResponseEntity.created(location).eTag(currentEtag).body(response);
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
