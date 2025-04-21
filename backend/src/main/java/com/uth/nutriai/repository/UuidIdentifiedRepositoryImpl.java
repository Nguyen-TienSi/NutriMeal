package com.uth.nutriai.repository;

import java.util.UUID;

import org.springframework.data.mongodb.core.MongoOperations;
import org.springframework.data.mongodb.repository.query.MongoEntityInformation;
import org.springframework.data.mongodb.repository.support.SimpleMongoRepository;

import com.uth.nutriai.model.UuidIdentifiedEntity;

public class UuidIdentifiedRepositoryImpl<T extends UuidIdentifiedEntity> extends SimpleMongoRepository<T, UUID>
        implements IUuidIdentifiedRepository<T> {

    public UuidIdentifiedRepositoryImpl(MongoEntityInformation<T, UUID> metadata, MongoOperations mongoOperations) {
        super(metadata, mongoOperations);
    }
}
