package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.ICommentDao;
import com.uth.nutriai.dto.request.CommentCreateDto;
import com.uth.nutriai.dto.response.CommentDetailDto;
import com.uth.nutriai.dto.response.CommentSummaryDto;
import com.uth.nutriai.mapper.ICommentMapper;
import com.uth.nutriai.model.domain.Comment;
import com.uth.nutriai.service.ICommentService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

@AllArgsConstructor
@Service
public class CommentServiceImpl implements ICommentService {

    private ICommentDao commentDao;
    private ICommentMapper commentMapper;

    @Override
    public List<CommentSummaryDto> findCommentsByUserPostId(UUID id) {
        List<Comment> commentList = commentDao.findCommentsByUserPostId(id);
        return commentMapper.mapToCommentSummaryDtoList(commentList);
    }

    @Override
    public CommentDetailDto createComment(CommentCreateDto commentCreateDto) {
        return null;
    }

    @Override
    public String currentEtag(UUID id) {
        Comment comment = commentDao.findById(id).orElse(null);
        return EtagUtil.generateEtag(Objects.requireNonNull(comment));
    }
}
