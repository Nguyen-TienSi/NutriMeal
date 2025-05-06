package com.uth.nutriai.service;

import com.github.fge.jsonpatch.JsonPatch;
import com.github.fge.jsonpatch.JsonPatchException;

import java.io.IOException;

public interface IJsonPatchService {

    <T> T applyPatch(JsonPatch jsonPatch, T object, Class<T> className) throws JsonPatchException, IOException;
}
