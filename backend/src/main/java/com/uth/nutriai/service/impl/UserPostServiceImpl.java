package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IUserPostDao;
import com.uth.nutriai.dto.request.UserPostCreateDto;
import com.uth.nutriai.dto.response.UserPostDetailDto;
import com.uth.nutriai.dto.response.UserPostSummaryDto;
import com.uth.nutriai.mapper.IUserPostMapper;
import com.uth.nutriai.model.domain.UserPost;
import com.uth.nutriai.service.IUserPostService;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@AllArgsConstructor
@Service
public class UserPostServiceImpl implements IUserPostService {

    private IUserPostDao userPostDao;
    private IUserPostMapper userPostMapper;

    @Override
    public List<UserPostSummaryDto> findAllUserPosts() {
        PageRequest pageRequest = PageRequest.of(0, 5);
        Page<UserPost> userPostPage = userPostDao.findAll(pageRequest);
        return userPostMapper.mapToUserPostSummaryDtoList(userPostPage.getContent());
    }

    @Override
    public UserPostDetailDto createUserPost(UserPostCreateDto userPostCreateDto) {
        return null;
    }
}
