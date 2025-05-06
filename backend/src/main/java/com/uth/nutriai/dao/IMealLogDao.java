package com.uth.nutriai.dao;

import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.User;

import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.Optional;

public interface IMealLogDao extends IDao<MealLog, UUID> {

    List<MealLog> findByTrackingDateAndUser(Date date, User user);
}
