package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.dto.response.StreakDetailDto;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.mapper.IHealthTrackingMapper;
import com.uth.nutriai.mapper.IRecipeMapper;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.service.IStatisticService;
import com.uth.nutriai.utils.SecurityUtils;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
public class StatisticServiceImpl implements IStatisticService {

    private IMealLogDao mealLogDao;
    private IUserDao userDao;
    private IHealthTrackingDao healthTrackingDao;
    private IRecipeMapper recipeMapper;
    private IHealthTrackingMapper healthTrackingMapper;

    @Override
    public List<RecipeSummaryDto> findFavoriteRecipesByUser() {

        String userId = SecurityUtils.extractAccountId();
        User user = userDao.findByUserId(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with userId: " + userId));

        List<MealLog> mealLogList = mealLogDao.findAllByUser(user);

        Map<Recipe, Long> recipeCountMap = mealLogList.stream()
                .flatMap(mealLog -> mealLog.getRecipes().stream())
                .collect(Collectors.groupingBy(
                        recipe -> recipe,
                        Collectors.counting()
                ));

        List<Recipe> sortedRecipes = recipeCountMap.entrySet().stream()
                .sorted(Map.Entry.<Recipe, Long>comparingByValue().reversed())
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        return recipeMapper.mapToRecipeSummaryDtoList(sortedRecipes);
    }

    @Override
    public List<HealthTrackingDetailDto> findHealthTrackingByUserAndTrackingDateBetween() {

        String userId = SecurityUtils.extractAccountId();
        User user = userDao.findByUserId(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with userId: " + userId));

        Calendar calendar = Calendar.getInstance();

        // Set start date to first day of current month
        calendar.set(Calendar.DAY_OF_MONTH, 1);
        calendar.set(Calendar.HOUR_OF_DAY, 0);
        calendar.set(Calendar.MINUTE, 0);
        calendar.set(Calendar.SECOND, 0);
        calendar.set(Calendar.MILLISECOND, 0);
        Date startDate = calendar.getTime();

        // Set end date to last day of current month
        calendar.set(Calendar.DAY_OF_MONTH, calendar.getActualMaximum(Calendar.DAY_OF_MONTH));
        calendar.set(Calendar.HOUR_OF_DAY, 23);
        calendar.set(Calendar.MINUTE, 59);
        calendar.set(Calendar.SECOND, 59);
        calendar.set(Calendar.MILLISECOND, 999);
        Date endDate = calendar.getTime();

        List<HealthTracking> healthTrackingList = healthTrackingDao.findByUserAndTrackingDateBetween(user, startDate, endDate);

        return healthTrackingMapper.mapToHealthTrackingDetailDtoList(healthTrackingList);
    }

    @Override
    public StreakDetailDto findStreak() {

        String userId = SecurityUtils.extractAccountId();
        User user = userDao.findByUserId(userId).orElseThrow(() -> new ResourceNotFoundException("User not found with id: " + userId));

        List<HealthTracking> healthTrackingList = healthTrackingDao.findAllByUser(user);

        int currentStreak = 0;
        int longestStreak = 0;
        int tempStreak = 0;

        healthTrackingList.sort((ht1, ht2) -> ht2.getTrackingDate().compareTo(ht1.getTrackingDate()));

        if (!healthTrackingList.isEmpty()) {
            Date currentDate = new Date();
            Date lastTrackedDate = healthTrackingList.get(0).getTrackingDate();

            // Check if the last tracking was done today or yesterday
            long daysDiff = (currentDate.getTime() - lastTrackedDate.getTime()) / (1000 * 60 * 60 * 24);
            if (daysDiff <= 1) {
                currentStreak = 1;
                tempStreak = 1;

                // Check consecutive days
                for (int i = 0; i < healthTrackingList.size() - 1; i++) {
                    Date date1 = healthTrackingList.get(i).getTrackingDate();
                    Date date2 = healthTrackingList.get(i + 1).getTrackingDate();

                    long diff = (date1.getTime() - date2.getTime()) / (1000 * 60 * 60 * 24);

                    if (diff == 1) {
                        currentStreak++;
                        tempStreak++;
                    } else {
                        if (tempStreak > longestStreak) {
                            longestStreak = tempStreak;
                        }
                        tempStreak = 1;
                    }
                }
            }

            if (tempStreak > longestStreak) {
                longestStreak = tempStreak;
            }
        }

        return new StreakDetailDto(currentStreak, longestStreak);
    }
}
