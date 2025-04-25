package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.User;

import java.util.UUID;

public interface IUserDao extends IDao<User, UUID> {

    boolean existsByEmail(String email);

    User findByEmail(String email);
}
