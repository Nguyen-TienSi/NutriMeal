package com.uth.nutriai.event.listener;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import com.uth.nutriai.event.model.HealthTrackingUpdateEvent;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.model.domain.User;
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
    private IUserDao userDao;
    private IHealthTrackingDao healthTrackingDao;

    @Async
    @Override
    public void onApplicationEvent(@NonNull HealthTrackingUpdateEvent event) {

        MealLogUpdateDto mealLogUpdateDto = event.getMealLogUpdateDto();
        User user = userDao.findById(mealLogUpdateDto.userId()).orElseThrow(() -> new ResourceNotFoundException("User not found"));

        List<MealLog> mealLogs = mealLogDao.findByTrackingDateAndUser(mealLogUpdateDto.trackingDate(), user);

        HealthTracking healthTracking = healthTrackingDao.findByTrackingDateAndUser(mealLogUpdateDto.trackingDate(), user).orElseThrow(() -> new ResourceNotFoundException("HealthTracking not found"));

        // Merge existing consumed nutrients with meal log nutrients
        List<Nutrient> mergedNutrients = new ArrayList<>();

        for (MealLog mealLog : mealLogs) {
            for (Nutrient mealLogNutrient : mealLog.getConsumedNutrients()) {
                mergedNutrients.stream()
                        .filter(existingNutrient -> existingNutrient.getName().equals(mealLogNutrient.getName()))
                        .findFirst()
                        .ifPresentOrElse(existingNutrient -> existingNutrient.setValue(existingNutrient.getValue() + mealLogNutrient.getValue()),
                                () -> mergedNutrients.add(new Nutrient(mealLogNutrient.getName(), mealLogNutrient.getUnit(), mealLogNutrient.getValue()))
                        );
            }
        }

        // Update health tracking with merged nutrients
        healthTracking.setConsumedNutrients(mergedNutrients);
        healthTracking.setTotalNutrients(mergedNutrients.stream()
                .map(n -> new Nutrient(n.getName(), n.getUnit(), 100 * n.getValue() / mealLogs.size()))
                .toList());

        healthTrackingDao.save(healthTracking);
    }
}
