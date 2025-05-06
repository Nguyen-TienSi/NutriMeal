package com.uth.nutriai.service;

public interface UniqueValueService {
    boolean isUnique(Class<?> entityClass, String fieldName, Object value);
}

