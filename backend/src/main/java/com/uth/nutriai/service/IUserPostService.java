package com.uth.nutriai.service;

import com.uth.nutriai.dto.request.UserPostCreateDto;
import com.uth.nutriai.dto.response.UserPostDetailDto;
import com.uth.nutriai.dto.response.UserPostSummaryDto;

import java.util.List;

public interface IUserPostService {

    List<UserPostSummaryDto> findAllUserPosts();

    UserPostDetailDto createUserPost(UserPostCreateDto userPostCreateDto);
}
