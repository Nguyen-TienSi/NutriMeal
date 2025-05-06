package com.uth.nutriai.service.impl;

import com.google.api.client.googleapis.auth.oauth2.GoogleIdToken;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.mapper.IUserMapper;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.security.GoogleTokenVerifier;
import com.uth.nutriai.service.IUserService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

@Service
@AllArgsConstructor
public class UserServiceImpl implements IUserService {

    private IUserDao userDao;
    private IUserMapper userMapper;
    private GoogleTokenVerifier googleTokenVerifier;

    @Override
    public List<UserDetailDto> findAllUsers() {
        List<User> userList = userDao.findAll();
        return userMapper.mapToUserDetailDtoList(userList);
    }

    @Override
    public UserDetailDto findUserById(UUID id) {
        User user = userDao.findById(id).orElse(null);
        return userMapper.mapToUserDetailDto(user);
    }

    @Override
    public UserDetailDto createUser(String token, UserCreateDto userCreateDto) {
        GoogleIdToken.Payload userPayload = googleTokenVerifier.verify(token);

        String subject = userPayload.getSubject();
        String email = userPayload.getEmail();
        String name = (String) userPayload.get("name");
        String pictureUrl = (String) userPayload.get("picture");
        String authProvider = (String) userPayload.get("iss");

        if (userDao.existsByUserId(subject)) {
            return userMapper.mapToUserDetailDto(userDao.findByUserId(subject).orElse(null));
        }

        User user = userMapper.mapToUser(userCreateDto);

        user.setUserId(subject);
        user.setEmail(email);
        user.setName(name);
        user.setPictureUrl(pictureUrl);
        user.setAuthProvider(authProvider);

        return userMapper.mapToUserDetailDto(userDao.save(user));
    }

    @Override
    public void deleteUser(UUID id) {
        userDao.delete(id);
    }

    @Override
    public boolean isUserAvailable(String email) {
        return userDao.existsByEmail(email);
    }

    @Override
    public UserDetailDto findUserByEmail(String email) {
        User user = userDao.findByEmail(email).orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
        return userMapper.mapToUserDetailDto(user);
    }

    @Override
    public String currentEtag(String email) {
        User user = userDao.findByEmail(email).orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
        return EtagUtil.generateEtag(user);
    }
}
