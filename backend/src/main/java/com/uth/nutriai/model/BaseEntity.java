package com.uth.nutriai.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.experimental.SuperBuilder;
import org.springframework.data.annotation.*;
import org.springframework.data.mongodb.core.mapping.Field;
import org.springframework.data.mongodb.core.mapping.FieldType;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@SuperBuilder
public abstract class BaseEntity extends UuidIdentifiedEntity {

    @CreatedBy
    @Field("createdBy")
    protected String createdBy;

    @LastModifiedBy
    @Field("lastModifiedBy")
    protected String lastModifiedBy;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    @CreatedDate
    @Field(value = "createdAt", targetType = FieldType.DATE_TIME)
    public Date createdAt;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
    @LastModifiedDate
    @Field(value = "lastModifiedAt", targetType = FieldType.DATE_TIME)
    protected Date lastModifiedAt;

    @Version
    protected Long version;

    protected boolean isDeleted = false;
}
