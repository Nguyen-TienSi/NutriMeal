package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.MealLog;

import java.util.Date;
import java.util.List;
import java.util.UUID;

public interface IMealLogDao extends IDao<MealLog, UUID> {

    List<MealLog> findMealLogsByMealDate(Date date);
}
