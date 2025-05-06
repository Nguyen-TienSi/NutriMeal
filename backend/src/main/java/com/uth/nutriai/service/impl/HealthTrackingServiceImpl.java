package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.mapper.IHealthTrackingMapper;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.model.domain.User;
import com.uth.nutriai.service.IHealthTrackingService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.util.*;

@AllArgsConstructor
@Service
public class HealthTrackingServiceImpl implements IHealthTrackingService {

    private IHealthTrackingDao healthTrackingDao;
    private IUserDao userDao;
    private IHealthTrackingMapper healthTrackingMapper;

    @Override
    public HealthTrackingDetailDto findHealthTrackingByDate(Date trackingDate) {
        String userId = Optional.ofNullable(SecurityContextHolder.getContext().getAuthentication())
                .map(auth -> auth.getPrincipal() instanceof Jwt jwt ? jwt.getSubject() : null)
                .orElse(null);

        if (userId == null) {
            return null;
        }

        return userDao.findByUserId(userId)
                .map(user -> healthTrackingDao.findByTrackingDateAndUser(trackingDate, user)
                        .orElseGet(() -> healthTrackingDao.save(HealthTracking.builder()
                                .user(user)
                                .trackingDate(trackingDate)
                                .totalCalories(0.0)
                                .consumedNutrients(new ArrayList<>())
                                .build())))
                .map(healthTrackingMapper::mapToHealthTrackingDetailDto)
                .orElse(null);
    }

    @Override
    public String currentEtag(Date trackingDate) {
        var authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getPrincipal() instanceof Jwt jwt ? jwt.getSubject() : null;
        if (userId == null) return null;

        return userDao.findByUserId(userId)
                .flatMap(user -> healthTrackingDao.findByTrackingDateAndUser(trackingDate, user))
                .map(EtagUtil::generateEtag)
                .orElse(null);
    }
}
