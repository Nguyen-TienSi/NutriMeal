package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.response.UserPostDetailDto;
import com.uth.nutriai.dto.response.UserPostSummaryDto;
import com.uth.nutriai.model.BaseEntity;
import com.uth.nutriai.model.domain.UserPost;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface IUserPostMapper {

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(userPost))")
    @Mapping(target = "likeCount", expression = "java(calculateLikes(userPost))")
    @Mapping(target = "commentCount", expression = "java(calculateComments(userPost))")
    @Mapping(target = "shareCount", expression = "java(calculateShares(userPost))")
    UserPostDetailDto mapToUserPostDetailDto(UserPost userPost);

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(userPost))")
    @Mapping(target = "likeCount", expression = "java(calculateLikes(userPost))")
    @Mapping(target = "commentCount", expression = "java(calculateComments(userPost))")
    @Mapping(target = "shareCount", expression = "java(calculateShares(userPost))")
    UserPostSummaryDto mapToUserPostSummaryDto(UserPost userPost);

    List<UserPostSummaryDto> mapToUserPostSummaryDtoList(List<UserPost> userPostList);

    default int calculateLikes(BaseEntity entity) {
        return ((UserPost) entity).getLikedBy().size();
    }

    default int calculateComments(BaseEntity entity) {
        return -1;
    }

    default int calculateShares(BaseEntity entity) {
        return ((UserPost) entity).getShareBy().size();
    }
}
