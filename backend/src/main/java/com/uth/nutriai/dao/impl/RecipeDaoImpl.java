package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.IRecipeDao;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import com.uth.nutriai.repository.IRecipeRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.mongodb.core.query.Criteria;
import org.springframework.data.mongodb.core.query.Query;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Slf4j
@Component
public class RecipeDaoImpl extends GenericDaoImpl<Recipe, UUID> implements IRecipeDao {
    public RecipeDaoImpl(IRecipeRepository repository) {
        super(repository);
    }

    @Override
    public List<Recipe> findByTimeOfDay(String mealTime) {

        List<TimeOfDay> timeOfDayList = new ArrayList<>();

        switch (mealTime.toLowerCase()) {
            case "breakfast":
                timeOfDayList.add(TimeOfDay.MORNING);
                break;
            case "lunch":
                timeOfDayList.add(TimeOfDay.NOON);
                timeOfDayList.add(TimeOfDay.AFTERNOON);
                break;
            case "dinner":
                timeOfDayList.add(TimeOfDay.EVENING);
                timeOfDayList.add(TimeOfDay.NIGHT);
                break;
        }

        return  ((IRecipeRepository) repository).findByTimesOfDayIsLike(timeOfDayList);
    }

    @Override
    public boolean existsByField(String field, Object value) {
        Query query = new Query();

        Criteria criteria = Criteria.where(field);

        if (value instanceof String) {
            criteria.regex((String) value, "i");
        } else {
            criteria.is(value);
        }

        query.addCriteria(criteria);
        return mongoTemplate.exists(query, Recipe.class);
    }

    @Override
    public List<Recipe> findByField(String field, Object value) {
        return findByField(field, value, Recipe.class);
    }
}