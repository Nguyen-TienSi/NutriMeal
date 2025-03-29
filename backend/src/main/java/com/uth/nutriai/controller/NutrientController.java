package com.uth.nutriai.controller;

import com.uth.nutriai.model.entity.Nutrient;
import com.uth.nutriai.service.NutrientService;
import lombok.AllArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/nutrient")
@AllArgsConstructor
public class NutrientController {

    private final NutrientService nutrientService;

    @GetMapping("/all")
    public List<Nutrient> getAllNutrients() {
        return nutrientService.getAllNutrients();
    }
}
