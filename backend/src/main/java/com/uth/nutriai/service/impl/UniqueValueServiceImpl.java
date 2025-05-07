package com.uth.nutriai.service.impl;

import com.uth.nutriai.service.UniqueValueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import java.util.Collection;

@Service
public class UniqueValueServiceImpl implements UniqueValueService {

    @Autowired
    private MongoTemplate mongoTemplate;

    @Override
    public boolean isUnique(Class<?> entityClass, String fieldName, Object value) {
        if (value == null) {
            return true;
        }

        if (value instanceof Collection<?> collection) {
            return collection.stream()
                    .noneMatch(item -> mongoTemplate.exists(
                            new Query(Criteria.where(fieldName).is(item)),
                            entityClass));
        }

        Query query = new Query(Criteria.where(fieldName).is(value));
        return !mongoTemplate.exists(query, entityClass);
    }
}
