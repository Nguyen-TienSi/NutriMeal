package com.uth.nutriai.utils;

import com.uth.nutriai.model.BaseEntity;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Base64;

public class EtagUtil {

    public static String generateEtag(BaseEntity entity) {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            String data = entity.getId().toString() + entity.getVersion() + entity.getLastModifiedAt().toString();
            byte[] hash = digest.digest(data.getBytes(StandardCharsets.UTF_8));
            return String.format("\"%s\"", Base64.getEncoder().encodeToString(hash));
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Unable to generate ETag", e);
        }
    }
}
