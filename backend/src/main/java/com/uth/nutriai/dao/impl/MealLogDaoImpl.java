package com.uth.nutriai.dao.impl;

import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.repository.IMealLogRepository;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@Component
public class MealLogDaoImpl extends GenericDaoImpl<MealLog, UUID> implements IMealLogDao {
    public MealLogDaoImpl(IMealLogRepository repository) {
        super(repository);
    }

    @Override
    public List<MealLog> findByTrackingDateAndUser(Date trackingDate, User user) {
        return ((IMealLogRepository) repository).findByTrackingDateAndUser(trackingDate, user);
    }

    @Override
    public List<MealLog> findAllByUser(User user) {
        return ((IMealLogRepository) repository).findAllByUser(user);
    }
}
