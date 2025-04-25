package com.uth.nutriai.model.domain;

import com.uth.nutriai.model.BaseEntity;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.mongodb.core.mapping.DBRef;
import org.springframework.data.mongodb.core.mapping.Document;

@NoArgsConstructor
@AllArgsConstructor
@Getter
@Setter
@SuperBuilder
@Document(collection = "user_post_comments")
public class Comment extends BaseEntity {
    @DBRef
    private UserPost userPost;
    private String content;
}
