package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.Comment;

import java.util.List;
import java.util.UUID;

public interface ICommentDao extends IDao<Comment, UUID> {

    List<Comment> findCommentsByUserPostId(UUID postId);
}
