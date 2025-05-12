package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IHealthTrackingDao;
import com.uth.nutriai.dao.IUserDao;
import com.uth.nutriai.dto.response.HealthTrackingDetailDto;
import com.uth.nutriai.mapper.IHealthTrackingMapper;
import com.uth.nutriai.model.domain.HealthTracking;
import com.uth.nutriai.service.IHealthTrackingService;
import com.uth.nutriai.utils.EtagUtils;
import com.uth.nutriai.utils.SecurityUtils;
import lombok.AllArgsConstructor;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.OAuth2AuthenticatedPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;

@AllArgsConstructor
@Service
public class HealthTrackingServiceImpl implements IHealthTrackingService {

    private IHealthTrackingDao healthTrackingDao;
    private IUserDao userDao;
    private IHealthTrackingMapper healthTrackingMapper;

    @Override
    public HealthTrackingDetailDto findHealthTrackingByDate(Date trackingDate) {
        String userId = SecurityUtils.extractAccountId();

        if (userId == null) {
            return null;
        }

        return userDao.findByUserId(userId)
                .map(user -> healthTrackingDao.findByTrackingDateAndUser(trackingDate, user)
                        .orElseGet(() -> {
                            Date today = new Date();
                            if (!trackingDate.toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate()
                                    .isEqual(today.toInstant().atZone(java.time.ZoneId.systemDefault()).toLocalDate())) {
                                return null;
                            }
                            return healthTrackingDao.save(HealthTracking.builder()
                                    .user(user)
                                    .trackingDate(trackingDate)
                                    .totalCalories(2000.0)
                                    .consumedNutrients(new ArrayList<>())
                                    .totalNutrients(new ArrayList<>())
                                    .build());
                        }))
                .map(healthTrackingMapper::mapToHealthTrackingDetailDto)
                .orElse(null);
    }

    @Override
    public String currentEtag(Date trackingDate) {
        var authentication = SecurityContextHolder.getContext().getAuthentication();
        String userId = authentication.getPrincipal() instanceof Jwt jwt ? jwt.getSubject() :
                authentication.getPrincipal() instanceof OAuth2AuthenticatedPrincipal oauth2Principal ? oauth2Principal.getName() : null;
        if (userId == null) return null;

        return userDao.findByUserId(userId)
                .flatMap(user -> healthTrackingDao.findByTrackingDateAndUser(trackingDate, user))
                .map(EtagUtils::generateEtag)
                .orElse(null);
    }
}
