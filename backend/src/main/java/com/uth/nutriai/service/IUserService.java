package com.uth.nutriai.service;

import java.util.List;
import java.util.UUID;

import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.UserDetailDto;

public interface IUserService {

    List<UserDetailDto> findAllUsers();

    UserDetailDto findUserById(UUID id);

    UserDetailDto createUser(String token, UserCreateDto userCreateDto);

    void deleteUser(UUID id);

    boolean isUserAvailable(String email);

    UserDetailDto findUserByEmail(String email);

    String currentEtag(String email);
}
