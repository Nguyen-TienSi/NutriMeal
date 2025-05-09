package com.uth.nutriai.dto.internal;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

@Data
public class FacebookUserDto {
    private String id;
    private String name;
    private String email;
    private Picture picture;

    @Data
    public static class Picture {
        private Data data;

        @lombok.Data
        public static class Data {
            private String height;
            private String width;
            private String url;
            @JsonProperty("is_silhouette")
            private Boolean isSilhouette;

        }
    }
}
