package com.uth.nutriai.repository;

import com.uth.nutriai.model.domain.UserPost;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
public interface IUserPostRepository extends MongoRepository<UserPost, UUID> {
}
