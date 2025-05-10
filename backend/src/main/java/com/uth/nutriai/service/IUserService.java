package com.uth.nutriai.service;

import java.util.List;
import java.util.UUID;

import com.github.fge.jsonpatch.JsonPatch;
import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.UserDetailDto;

public interface IUserService {

    List<UserDetailDto> findAllUsers();

    UserDetailDto findUserById(UUID id);

    UserDetailDto createUser(UserCreateDto userCreateDto);

    void deleteUser(UUID id);

    UserDetailDto patchUser(JsonPatch jsonPatch);

    boolean isUserAvailable(String userId);

    UserDetailDto findUserByUserId(String userId);

    UserDetailDto findUserByEmail(String email);

    String currentEtag(String userId);
}
