package com.uth.nutriai.repository;

import com.uth.nutriai.model.entity.User;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.config.EnableMongoRepositories;
import org.springframework.stereotype.Repository;

import java.util.UUID;

@Repository
@EnableMongoRepositories
public interface IUserRepository extends MongoRepository<User, UUID> {
}
