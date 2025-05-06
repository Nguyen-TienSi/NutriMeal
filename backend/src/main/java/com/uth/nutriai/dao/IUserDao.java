package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.User;

import java.util.Optional;
import java.util.UUID;

public interface IUserDao extends IDao<User, UUID> {

    boolean existsByEmail(String email);

    Optional<User> findByEmail(String email);

    Optional<User> findByUserId(String userId);

    boolean existsByUserId(String userId);
}
