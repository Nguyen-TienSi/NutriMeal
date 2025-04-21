package com.uth.nutriai.mapper;

import com.uth.nutriai.dto.request.UserCreateDto;
import com.uth.nutriai.dto.response.AuditMetadataDto;
import com.uth.nutriai.dto.response.UserDetailDto;
import com.uth.nutriai.model.domain.User;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.util.List;

@Mapper(componentModel = "spring", imports = AuditMetadataDto.class)
public interface IUserMapper {

    User mapToUser(UserCreateDto userCreateDto);

    @Mapping(target = "auditMetadataDto", expression = "java(new AuditMetadataDto(user))")
    UserDetailDto mapToUserDetailDto(User user);

    List<UserDetailDto> mapToUserDetailDtoList(List<User> userList);
}
