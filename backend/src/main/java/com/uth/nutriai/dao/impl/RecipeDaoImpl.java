package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.IRecipeDao;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.repository.IRecipeRepository;
import org.springframework.stereotype.Component;

import java.util.UUID;

@Component
public class RecipeDaoImpl extends GenericDaoImpl<Recipe, UUID> implements IRecipeDao {
    public RecipeDaoImpl(IRecipeRepository repository) {
        super(repository);
    }
}
