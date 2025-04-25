package com.uth.nutriai.controller;

import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.CommentSummaryDto;
import com.uth.nutriai.service.ICommentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/comments", produces = "application/vnd.company.app-v1+json")
public class CommentController {

    @Autowired
    private ICommentService commentService;

    @GetMapping("/search")
    public ResponseEntity<ApiResponse<List<CommentSummaryDto>>> findCommentsByUserPostId(@RequestParam UUID id) {
        List<CommentSummaryDto> commentSummaryDtoList = commentService.findCommentsByUserPostId(id);
        if (commentSummaryDtoList == null) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<CommentSummaryDto>> response = new ApiResponse<>(commentSummaryDtoList);
        return ResponseEntity.ok(response);
    }
}
