package com.uth.nutriai.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Field;

import java.util.Optional;
import java.util.UUID;

@NoArgsConstructor
@Getter
@SuperBuilder
public abstract class UuidIdentifiedEntity {
    @Id
    @Field("_id")
    protected UUID id;

    public void setId(UUID id) {
        Optional.ofNullable(this.id)
                .ifPresent(existingId -> {
                    throw new UnsupportedOperationException("Record is already defined");
                });
        this.id = id;
    }

}
