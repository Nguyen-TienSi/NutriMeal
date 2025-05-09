package com.uth.nutriai.service.impl;

import com.github.fge.jsonpatch.JsonPatch;
import com.github.fge.jsonpatch.JsonPatchException;
import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dao.IRecipeDao;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.internal.MealLogUpdateDto;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.event.model.HealthTrackingUpdateEvent;
import com.uth.nutriai.exception.ResourceNotFoundException;
import com.uth.nutriai.mapper.IMealLogMapper;
import com.uth.nutriai.mapper.IRecipeMapper;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.Nutrient;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import com.uth.nutriai.service.IJsonPatchService;
import com.uth.nutriai.service.IMealLogService;
import com.uth.nutriai.utils.EtagUtils;
import com.uth.nutriai.utils.SecurityUtils;
import lombok.AllArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@AllArgsConstructor
@Service
public class MealLogServiceImpl implements IMealLogService {

    private IMealLogDao mealLogDao;
    private IUserDao userDao;
    private IRecipeDao recipeDao;
    private IMealLogMapper mealLogMapper;
    private IRecipeMapper recipeMapper;
    private IJsonPatchService jsonPatchService;
    private ApplicationEventPublisher applicationEventPublisher;

    @Override
    public List<MealLogSummaryDto> findMealLogsByTrackingDate(Date trackingDate) {
        String userId = SecurityUtils.extractAccountId();

        if (userId == null) {
            return Collections.emptyList();
        }

        User user = userDao.findByUserId(userId)
                .orElseThrow(() -> new ResourceNotFoundException("User not found with userId: " + userId));

        List<MealLog> mealLogList = mealLogDao.findByTrackingDateAndUser(trackingDate, user);

        if (mealLogList.isEmpty()) {
            mealLogList = Arrays.stream(TimeOfDay.values())
                    .filter(tod -> List.of(TimeOfDay.MORNING, TimeOfDay.NOON, TimeOfDay.EVENING, TimeOfDay.NIGHT).contains(tod))
                    .map(timeOfDay -> {
                        MealLog mealLog = new MealLog();
                        mealLog.setUser(user);
                        mealLog.setTrackingDate(trackingDate);
                        mealLog.setTimeOfDay(timeOfDay);
                        mealLog.setTotalCalories(0.0);
                        mealLog.setRecipes(new ArrayList<>());
                        mealLog.setConsumedNutrients(new ArrayList<>());
                        return mealLogDao.save(mealLog);
                    })
                    .collect(Collectors.toList());
        }

        return mealLogMapper.mapToMealLogSummaryDtoList(mealLogList);
    }

    @Override
    public MealLogDetailDto findMealLogById(UUID id) {
        MealLog mealLog = mealLogDao.findById(id).orElseThrow(() -> new ResourceNotFoundException("MealLog not found with id: " + id));
        return mealLogMapper.mapToMealLogDetailDto(mealLog);
    }

    @SneakyThrows({JsonPatchException.class, IOException.class})
    @Override
    public MealLogDetailDto patchMealLog(UUID id, JsonPatch jsonPatch) {
        MealLog mealLog = mealLogDao.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("MealLog not found with id: " + id));

        MealLog patchedMealLog = jsonPatchService.applyPatch(jsonPatch, mealLog, MealLog.class);

        updateConsumedNutrients(patchedMealLog);

        MealLog savedMealLog = mealLogDao.save(patchedMealLog);

        publishHealthTrackingUpdate(savedMealLog);

        return mealLogMapper.mapToMealLogDetailDto(savedMealLog);
    }

    private void updateConsumedNutrients(MealLog mealLog) {
        Map<String, Nutrient> nutrientMap = mealLog.getRecipes().stream()
                .map(recipe -> recipeDao.findById(recipe.getId())
                        .orElseThrow(() -> new ResourceNotFoundException("Recipe not found: " + recipe.getId())))
                .flatMap(recipe -> recipe.getNutrients().stream())
                .collect(Collectors.groupingBy(
                        Nutrient::getName,
                        Collectors.reducing(
                                null,
                                nutrient -> Nutrient.builder()
                                        .name(nutrient.getName())
                                        .unit(nutrient.getUnit())
                                        .value(nutrient.getValue())
                                        .build(),
                                (n1, n2) -> {
                                    if (n1 == null) return n2;
                                    n1.setValue(n1.getValue() + n2.getValue());
                                    return n1;
                                }
                        )
                ));

        List<Nutrient> consumedNutrients = new ArrayList<>(nutrientMap.values());
        List<Nutrient> totalNutrients = consumedNutrients.stream()
                .map(n -> Nutrient.builder()
                        .name(n.getName())
                        .unit(n.getUnit())
                        .value(0.0)
                        .build())
                .collect(Collectors.toList());

        mealLog.setConsumedNutrients(consumedNutrients);
        mealLog.setTotalNutrients(totalNutrients);
    }

    private void publishHealthTrackingUpdate(MealLog mealLog) {
        MealLogUpdateDto mealLogUpdateDto = mealLogMapper.mapToMealLogUpdateDto(mealLog);
        applicationEventPublisher.publishEvent(new HealthTrackingUpdateEvent(this, mealLogUpdateDto));
    }

    @Override
    public boolean isMealLogAvailable(UUID id) {
        return mealLogDao.existsById(id);
    }

    @Override
    public String currentEtag(UUID id) {
        MealLog mealLog = mealLogDao.findById(id).orElse(null);
        return EtagUtils.generateEtag(Objects.requireNonNull(mealLog));
    }

    @Override
    public List<RecipeSummaryDto> findRecipesByMealLogId(UUID id) {
        MealLog mealLog = mealLogDao.findById(id).orElseThrow(() -> new ResourceNotFoundException("MealLog not found with id: " + id));
        List<Recipe> recipeList = mealLog.getRecipes();
        return recipeMapper.mapToRecipeSummaryDtoList(recipeList);
    }
}
