package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.UserPostSummaryDto;
import com.uth.nutriai.service.IUserPostService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping(value = "/api/user-posts", produces = "application/vnd.company.app-v1+json")
public class UserPostController {

    @Autowired
    private IUserPostService userPostService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<UserPostSummaryDto>>> findAllUserPosts() {
        List<UserPostSummaryDto> userPostSummaryDtoList = userPostService.findAllUserPosts();
        if (userPostSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }

        ApiResponse<List<UserPostSummaryDto>> response = new ApiResponse<>(userPostSummaryDtoList);
        return ResponseEntity.ok(response);
    }
}
