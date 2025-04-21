package com.uth.nutriai.repository;

import java.util.UUID;

import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.repository.NoRepositoryBean;

import com.uth.nutriai.model.UuidIdentifiedEntity;

@NoRepositoryBean
interface IUuidIdentifiedRepository<T extends UuidIdentifiedEntity> extends MongoRepository<T, UUID> {
}