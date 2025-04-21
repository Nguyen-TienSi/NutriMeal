package com.uth.nutriai.dao;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;

public interface IDao<T, ID> {

    boolean existsById(ID id);

    List<T> findAll();

    T findById(ID id);

    T save(T entity);

    T update(ID id, T entity);

    void delete(ID id);

    Page<T> findAll(Pageable pageable);
}
