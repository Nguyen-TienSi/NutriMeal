package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.Comment;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface ICommentRepository extends MongoRepository<Comment, UUID> {

    List<Comment> findCommentsByUserPostId(UUID postId);
}
