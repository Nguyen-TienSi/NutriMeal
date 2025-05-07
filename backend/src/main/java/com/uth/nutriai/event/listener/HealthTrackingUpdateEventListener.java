package com.uth.nutriai.event.listener;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import com.uth.nutriai.event.model.HealthTrackingUpdateEvent;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.Nutrient;
import lombok.AllArgsConstructor;
import org.springframework.context.ApplicationListener;
import org.springframework.lang.NonNull;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Component;

import java.util.ArrayList;
import java.util.List;

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

        // Merge existing consumed nutrients with meal log nutrients
        List<Nutrient> mergedNutrients = new ArrayList<>(healthTracking.getConsumedNutrients());
        for (Nutrient mealLogNutrient : mealLog.getConsumedNutrients()) {
            boolean found = false;
            for (Nutrient existingNutrient : mergedNutrients) {
                if (existingNutrient.getName().equals(mealLogNutrient.getName())) {
                    existingNutrient.setValue(existingNutrient.getValue() + mealLogNutrient.getValue());
                    found = true;
                    break;
                }
            }
            if (!found) {
                mergedNutrients.add(new Nutrient(mealLogNutrient.getName(), mealLogNutrient.getUnit(), mealLogNutrient.getValue()));
            }
        }

        // Update health tracking with merged nutrients
        healthTracking.setConsumedNutrients(mergedNutrients);
        healthTracking.setTotalNutrients(new ArrayList<>(mergedNutrients.stream().map(n -> new Nutrient(n.getName(), n.getUnit(), 0.0)).toList()));

        healthTrackingDao.save(healthTracking);
    }
}
