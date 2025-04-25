package com.uth.nutriai.model.domain;

import com.uth.nutriai.model.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "user_posts")
public class UserPost extends BaseEntity {

    @DBRef
    private List<User> likedBy;

    private String content;
    private String imageUrl;

    @DBRef
    private List<User> shareBy;
}
