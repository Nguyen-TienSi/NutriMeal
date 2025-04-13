package com.uth.nutriai.service;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.bson.Document;
import org.bson.types.ObjectId;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Service;

import com.uth.nutriai.exception.ResourceNotFoundException;

@Service
public class UserService {
    @Autowired
    private MongoTemplate mongoTemplate;

    public List<Map<String, Object>> getAllUsers() {
        Query query = new Query();
        return mongoTemplate.find(query, Document.class, "users").stream()
                .map(document -> (Map<String, Object>) document)
                .collect(Collectors.toList());
    }

    public Map<String, Object> findUserById(String id) {
        try {
            Query query = new Query(Criteria.where("_id").is(new ObjectId(id)));
            return mongoTemplate.findOne(query, Document.class, "users");
        } catch (IllegalArgumentException e) {
            throw new ResourceNotFoundException("Invalid user ID format: " + id);
        }
    }
}
