package com.uth.nutriai.repository;

import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import com.uth.nutriai.model.domain.User;

@Repository
public interface IUserRepository extends MongoRepository<User, UUID> {
}
