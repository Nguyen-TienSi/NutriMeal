package com.uth.nutriai.service;

import com.uth.nutriai.model.entity.Nutrient;
import com.uth.nutriai.repository.INutrientRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@AllArgsConstructor
public class NutrientService {

    private final INutrientRepository nutrientRepository;

    public List<Nutrient> getAllNutrients() {
        return nutrientRepository.findAll();
    }
}
