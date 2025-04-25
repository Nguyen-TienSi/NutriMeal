package com.uth.nutriai.service;

import com.uth.nutriai.dto.request.CommentCreateDto;
import com.uth.nutriai.dto.response.CommentDetailDto;
import com.uth.nutriai.dto.response.CommentSummaryDto;

import java.util.List;
import java.util.UUID;

public interface ICommentService {

    List<CommentSummaryDto> findCommentsByUserPostId(UUID id);

    CommentDetailDto createComment(CommentCreateDto commentCreateDto);

    String currentEtag(UUID id);
}
