package com.uth.nutriai.event.listener;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import com.uth.nutriai.event.model.HealthTrackingUpdateEvent;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.MealLog;
import lombok.AllArgsConstructor;
import org.springframework.context.ApplicationListener;
import org.springframework.lang.NonNull;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

@AllArgsConstructor
@Component
public class HealthTrackingUpdateEventListener implements ApplicationListener<HealthTrackingUpdateEvent> {

    private IMealLogDao mealLogDao;
    private IHealthTrackingDao healthTrackingDao;

    @Async
    @Override
    public void onApplicationEvent(@NonNull HealthTrackingUpdateEvent event) {

        MealLogUpdateDto mealLogUpdateDto = event.getMealLogUpdateDto();

        MealLog mealLog = mealLogDao.findById(mealLogUpdateDto.id())
                .orElseThrow(() -> new ResourceNotFoundException("MealLog not found"));

        HealthTracking healthTracking = healthTrackingDao.findByTrackingDateAndUser(mealLogUpdateDto.trackingDate(), mealLog.getUser())
                .orElseThrow(() -> new ResourceNotFoundException("HealthTracking not found"));

        // Update health-tracking with calculated nutrients
        healthTracking.setConsumedNutrients(new ArrayList<>(mealLog.getConsumedNutrients()));

        healthTrackingDao.save(healthTracking);
    }
}
