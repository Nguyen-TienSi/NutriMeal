package com.uth.nutriai.dao.impl;

import java.util.UUID;

import com.uth.nutriai.dao.IUserDao;
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
    public User findByEmail(String email) {
        return findByField("email", email, User.class).get(0);
    }
}
