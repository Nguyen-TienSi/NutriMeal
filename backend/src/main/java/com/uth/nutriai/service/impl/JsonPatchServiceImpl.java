package com.uth.nutriai.service.impl;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.github.fge.jsonpatch.JsonPatch;
import com.github.fge.jsonpatch.JsonPatchException;
import com.uth.nutriai.exception.InvalidPatchException;
import com.uth.nutriai.service.IJsonPatchService;
import jakarta.validation.ConstraintViolation;
import jakarta.validation.ConstraintViolationException;
import jakarta.validation.Validator;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.Set;

@AllArgsConstructor
@Service
public class JsonPatchServiceImpl implements IJsonPatchService {

    private final ObjectMapper objectMapper;
    private final Validator validator;

    @Override
    public <T> T applyPatch(JsonPatch jsonPatch, T object, Class<T> className) throws JsonPatchException, IOException {
        try {
            JsonNode patched = jsonPatch.apply(objectMapper.convertValue(object, JsonNode.class));

            T patchedObject = objectMapper.treeToValue(patched, className);

            validate(patchedObject);

            return patchedObject;
        } catch (JsonPatchException | IOException e) {
            throw e;
        }
//        catch (ConstraintViolationException e) {
//            throw e;
//        }
        catch (Exception e) {
            throw new InvalidPatchException("Invalid patch data: " + e.getMessage(), e);
        }
    }

    private void validate(Object object) {
        Set<ConstraintViolation<Object>> violations = validator.validate(object);
        if (!violations.isEmpty()) {
            throw new ConstraintViolationException(violations);
        }
    }
}
