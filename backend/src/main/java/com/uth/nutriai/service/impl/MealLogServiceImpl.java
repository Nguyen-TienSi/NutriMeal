package com.uth.nutriai.service.impl;

import com.uth.nutriai.dao.IMealLogDao;
import com.uth.nutriai.dto.response.MealLogDetailDto;
import com.uth.nutriai.dto.response.MealLogSummaryDto;
import com.uth.nutriai.mapper.IMealLogMapper;
import com.uth.nutriai.model.domain.MealLog;
import com.uth.nutriai.service.IMealLogService;
import com.uth.nutriai.utils.EtagUtil;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;
import java.util.UUID;

@AllArgsConstructor
@Service
public class MealLogServiceImpl implements IMealLogService {

    private IMealLogDao mealLogDao;
    private IMealLogMapper mealLogMapper;

    @Override
    public List<MealLogSummaryDto> findMealLogsByDate(Date mealDate) {
        List<MealLog> mealLogList = mealLogDao.findMealLogsByMealDate(mealDate);
        return mealLogMapper.mapToMealLogSummaryDtoList(mealLogList);
    }

    @Override
    public MealLogDetailDto findMealLogById(UUID id) {
        MealLog mealLog = mealLogDao.findById(id);
        return mealLogMapper.mapToMealLogDetailDto(mealLog);
    }

    @Override
    public boolean isMealLogAvailable(UUID id) {
        return mealLogDao.existsById(id);
    }

    @Override
    public String currentEtag(UUID id) {
        MealLog mealLog = mealLogDao.findById(id);
        return EtagUtil.generateEtag(mealLog);
    }
}
