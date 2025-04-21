package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IRecipeDao;
import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.mapper.IRecipeMapper;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.service.IRecipeService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;
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
        Recipe recipe = recipeDao.findById(id);
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
    public String currentEtag(UUID id) {
        Recipe recipe = recipeDao.findById(id);
        return EtagUtil.generateEtag(recipe);
    }
}
