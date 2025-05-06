package com.uth.nutriai.dao.impl;

import java.util.Optional;
import java.util.UUID;

import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.exception.ResourceNotFoundException;
import org.springframework.stereotype.Component;

import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.repository.IUserRepository;

@Component
public class UserDaoImpl extends GenericDaoImpl<User, UUID> implements IUserDao {
    public UserDaoImpl(IUserRepository repository) {
        super(repository);
    }

    @Override
    public boolean existsByEmail(String email) {
        return !findByField("email", email, User.class).isEmpty();
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return ((IUserRepository) repository).findByEmail(email);
    }

    @Override
    public Optional<User> findByUserId(String userId) {
        return ((IUserRepository) repository).findByUserId(userId);
    }

    @Override
    public boolean existsByUserId(String userId) {
        return ((IUserRepository) repository).existsByUserId(userId);
    }
}
