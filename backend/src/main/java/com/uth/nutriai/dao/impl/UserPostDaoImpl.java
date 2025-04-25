package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.IUserPostDao;
import com.uth.nutriai.model.domain.UserPost;
import com.uth.nutriai.repository.IUserPostRepository;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class UserPostDaoImpl extends GenericDaoImpl<UserPost, UUID> implements IUserPostDao {
    public UserPostDaoImpl(IUserPostRepository repository) {
        super(repository);
    }
}
