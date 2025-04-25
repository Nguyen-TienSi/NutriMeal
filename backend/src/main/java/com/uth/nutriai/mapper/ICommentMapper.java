package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.response.CommentDetailDto;
import com.uth.nutriai.dto.response.CommentSummaryDto;
import com.uth.nutriai.model.domain.Comment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring")
public interface ICommentMapper {

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(comment))")
    @Mapping(target = "userPostId", source = "userPost.id")
    CommentSummaryDto mapToCommentSummaryDto(Comment comment);

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(comment))")
    @Mapping(target = "userPostId", source = "userPost.id")
    CommentDetailDto mapToCommentDetailDto(Comment comment);

    List<CommentSummaryDto> mapToCommentSummaryDtoList(List<Comment> commentList);
}
