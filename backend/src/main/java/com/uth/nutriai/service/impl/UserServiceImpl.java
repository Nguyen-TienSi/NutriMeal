package com.uth.nutriai.service.impl;

import com.github.fge.jsonpatch.JsonPatch;
import com.github.fge.jsonpatch.JsonPatchException;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.internal.UserInfo;
import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.mapper.IUserMapper;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.service.IJsonPatchService;
import com.uth.nutriai.service.IUserService;
import com.uth.nutriai.utils.EtagUtils;
import com.uth.nutriai.utils.IAuthProvider;
import com.uth.nutriai.utils.SecurityUtils;
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.OAuth2AccessToken;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.oauth2.server.resource.authentication.BearerTokenAuthentication;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class UserServiceImpl implements IUserService {

    private final IUserDao userDao;
    private final IUserMapper userMapper;
    private final List<IAuthProvider> authProviders;
    private final IJsonPatchService jsonPatchService;

    @Override
    public List<UserDetailDto> findAllUsers() {
        return userMapper.mapToUserDetailDtoList(userDao.findAll());
    }

    @Override
    public UserDetailDto findUserById(UUID id) {
        return userDao.findById(id)
                .map(userMapper::mapToUserDetailDto)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + id));
    }

    @Override
    public UserDetailDto createUser(UserCreateDto userCreateDto) {
        String token = SecurityUtils.extractToken();

        if (token == null) {
            throw new IllegalStateException("No authentication token found");
        }

        UserInfo userInfo = authenticateUser(token);
        
        if (isUserAvailable(userInfo.userId())) {
            return findUserByUserId(userInfo.userId());
        }

        User user = userMapper.mapToUser(userCreateDto);

        user.setUserId(userInfo.userId());
        user.setEmail(userInfo.email());
        user.setName(userInfo.name());
        user.setPictureUrl(userInfo.pictureUrl());
        user.setAuthProvider(userInfo.authProvider());

        return userMapper.mapToUserDetailDto(userDao.save(user));
    }

    @Override
    public void deleteUser(UUID id) {
        if (!userDao.existsById(id)) {
            throw new ResourceNotFoundException("User not found with id: " + id);
        }
        userDao.delete(id);
    }

    @SneakyThrows({JsonPatchException.class, IOException.class})
    @Override
    public UserDetailDto patchUser(JsonPatch jsonPatch) {

        String userId = SecurityUtils.extractAccountId();
        User user = userDao.findByUserId(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with userId: " + userId));

        User patchedUser = jsonPatchService.applyPatch(jsonPatch, user, User.class);

        return userMapper.mapToUserDetailDto(userDao.save(patchedUser));
    }

    @Override
    public boolean isUserAvailable(String userId) {
        return userDao.existsByUserId(userId);
    }

    @Override
    public UserDetailDto findUserByEmail(String email) {
        User user = userDao.findByEmail(email)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with email: " + email));
        return userMapper.mapToUserDetailDto(user);
    }

    @Override
    public String currentEtag(String userId) {
        User user = userDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));
        return EtagUtils.generateEtag(user);
    }

    @Override
    public UserDetailDto findUserByUserId(String userId) {
        User user = userDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with userId: " + userId));
        return userMapper.mapToUserDetailDto(user);
    }

    private UserInfo authenticateUser(String token) {
        return authProviders.stream()
                .map(provider -> provider.extractUserInfo(token))
                .filter(Objects::nonNull)
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Invalid or unsupported authentication token"));
    }
}
