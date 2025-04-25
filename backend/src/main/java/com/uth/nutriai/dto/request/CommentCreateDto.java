package com.uth.nutriai.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CommentCreateDto(
        @NotBlank(message = "Content cannot be empty")
        @Size(max = 300, message = "Content must be less than 300 characters")
        String content
) {
}
