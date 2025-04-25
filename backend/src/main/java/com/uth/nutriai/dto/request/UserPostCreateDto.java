package com.uth.nutriai.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record UserPostCreateDto(
        @NotBlank(message = "Content cannot be empty")
        @Size(max = 500, message = "Content must be less than 500 characters")
        String content,

        @Pattern(regexp = "^(https?://).+", message = "Image URL must be a valid URL")
        String imageUrl
) {
}
