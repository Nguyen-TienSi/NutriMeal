package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.IDao;
import com.uth.nutriai.exception.ResourceNotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.core.MongoTemplate;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.data.mongodb.repository.MongoRepository;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
public abstract class GenericDaoImpl<T, ID> implements IDao<T, ID> {

    @Autowired
    protected MongoTemplate mongoTemplate;

    protected final MongoRepository<T, ID> repository;

    @Override
    public boolean existsById(ID id) {
        return repository.existsById(id);
    }

    @Override
    public List<T> findAll() {
        return repository.findAll();
    }

    @Override
    public T findById(ID id) {
        return repository.findById(id).orElse(null);
    }

    @Override
    public T save(T entity) {
        return repository.save(entity);
    }

    @Override
    public T update(ID id, T entity) {
        Optional<T> optional = repository.findById(id);
        if (optional.isPresent()) {
            T existingEntity = optional.get();
            BeanUtils.copyProperties(entity, existingEntity, "id", "createdBy", "lastModifiedBy", "createdAt", "lastModifiedAt", "version", "isDeleted");
            return repository.save(existingEntity);
        } else {
            throw new ResourceNotFoundException("Resource not found with id: " + id);
        }
    }

    @Override
    public void delete(ID id) {
        repository.deleteById(id);
    }

    public List<T> findByField(String fieldName, Object value, Class<T> className) {
        var query = new Query();
        query.addCriteria(Criteria.where(fieldName).is(value));
        return mongoTemplate.find(query, className);
    }

    public Page<T> findAll(Pageable pageable) {
        return repository.findAll(pageable);
    }
}
