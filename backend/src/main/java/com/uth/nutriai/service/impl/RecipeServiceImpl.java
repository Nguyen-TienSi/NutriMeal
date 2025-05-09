package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IRecipeDao;
import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.mapper.IRecipeMapper;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.service.IRecipeService;
import com.uth.nutriai.utils.EtagUtils;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

@Service
@AllArgsConstructor
public class RecipeServiceImpl implements IRecipeService {

    private IRecipeDao recipeDao;
    private IRecipeMapper recipeMapper;

    public boolean isRecipeAvailable(UUID id) {
        return recipeDao.existsById(id);
    }

    public List<RecipeSummaryDto> findAllRecipes() {
        PageRequest pageRequest = PageRequest.of(0, 5);
        Page<Recipe> recipePage = recipeDao.findAll(pageRequest);
        return recipeMapper.mapToRecipeSummaryDtoPage(recipePage).getContent();
    }

    @Override
    public RecipeDetailDto findRecipeById(UUID id) {
        Recipe recipe = recipeDao.findById(id).orElse(null);
        return recipeMapper.mapToRecipeDetailDto(recipe);
    }

    @Override
    public RecipeDetailDto createRecipe(RecipeCreateDto recipeCreateDto) {
        Recipe recipe = recipeMapper.mapToRecipe(recipeCreateDto);
        return recipeMapper.mapToRecipeDetailDto(recipeDao.save(recipe));
    }

    @Override
    public RecipeDetailDto updateRecipe(RecipeUpdateDto recipeUpdateDto) {
        Recipe recipe = recipeMapper.mapToRecipe(recipeUpdateDto);
        return recipeMapper.mapToRecipeDetailDto(recipeDao.update(recipeUpdateDto.id(), recipe));
    }

    @Override
    public void deleteRecipe(UUID id) {
        recipeDao.delete(id);
    }

    @Override
    public List<RecipeSummaryDto> findRecipesByMealTime(String mealTime, int pageNumber, int pageSize) {

        if (pageSize <= 0) {
            List<Recipe> recipeList = recipeDao.findByTimesOfDay(mealTime);
            return recipeMapper.mapToRecipeSummaryDtoList(recipeList);
        }

        PageRequest pageRequest = PageRequest.of(pageNumber, pageSize);
        Page<Recipe> recipePage = recipeDao.findByTimeOfDay(mealTime, pageRequest);
        return recipeMapper.mapToRecipeSummaryDtoList(recipePage.getContent());
    }

    @Override
    public boolean isRecipeAvailable(String fieldName, Object fieldValue) {
        return recipeDao.existsByField(fieldName, fieldValue);
    }

    @Override
    public List<RecipeSummaryDto> findRecipesByField(String fieldName, Object fieldValue) {
        List<Recipe> recipeList = recipeDao.findByField(fieldName, fieldValue);
        return recipeMapper.mapToRecipeSummaryDtoList(recipeList);
    }

    @Override
    public String currentEtag(UUID id) {
        Recipe recipe = recipeDao.findById(id).orElse(null);
        return EtagUtils.generateEtag(Objects.requireNonNull(recipe));
    }
}
