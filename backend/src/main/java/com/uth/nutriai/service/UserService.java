package com.uth.nutriai.service;

import com.uth.nutriai.model.entity.User;
import com.uth.nutriai.repository.IUserRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class UserService {

    private final IUserRepository userRepository;

    public List<User> getAllUsers() {
        return userRepository.findAll();
    }

}
