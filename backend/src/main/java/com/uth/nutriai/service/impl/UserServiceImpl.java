package com.uth.nutriai.service.impl;

import java.util.List;
import java.util.UUID;

import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.mapper.IUserMapper;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.service.IUserService;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.utils.EtagUtil;
import org.springframework.stereotype.Service;

import lombok.AllArgsConstructor;

@Service
@AllArgsConstructor
public class UserServiceImpl implements IUserService {

    private IUserDao userDao;
    private IUserMapper userMapper;

    @Override
    public List<UserDetailDto> findAllUsers() {
        List<User> userList = userDao.findAll();
        return userMapper.mapToUserDetailDtoList(userList);
    }

    @Override
    public UserDetailDto findUserById(UUID id) {
        User user = userDao.findById(id);
        return userMapper.mapToUserDetailDto(user);
    }

    @Override
    public UserDetailDto createUser(UserCreateDto userCreateDto) {
        User user = userMapper.mapToUser(userCreateDto);
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
        User user = userDao.findByEmail(email);
        return userMapper.mapToUserDetailDto(user);
    }

    @Override
    public String currentEtag(String email) {
        User user = userDao.findByEmail(email);
        return EtagUtil.generateEtag(user);
    }
}
