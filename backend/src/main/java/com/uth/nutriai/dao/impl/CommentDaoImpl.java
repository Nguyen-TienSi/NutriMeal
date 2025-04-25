package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.ICommentDao;
import com.uth.nutriai.model.domain.Comment;
import com.uth.nutriai.repository.ICommentRepository;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.UUID;

@Component
public class CommentDaoImpl extends GenericDaoImpl<Comment, UUID> implements ICommentDao {
    public CommentDaoImpl(ICommentRepository repository) {
        super(repository);
    }

    @Override
    public List<Comment> findCommentsByUserPostId(UUID postId) {
        return ((ICommentRepository) repository).findCommentsByUserPostId(postId);
    }
}
