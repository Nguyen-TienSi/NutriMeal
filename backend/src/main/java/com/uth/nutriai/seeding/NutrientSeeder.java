package com.uth.nutriai.seeding;

import com.uth.nutriai.model.entity.Nutrient;
import com.uth.nutriai.repository.INutrientRepository;
import com.uth.nutriai.repository.IUserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class NutrientSeeder implements CommandLineRunner {

    private final INutrientRepository nutrientRepository;

    @Override
    public void run(String... args) {
        if (nutrientRepository.count() == 0) {
            seedNutrients();
        }
    }

    private void seedNutrients() {
        Nutrient nutrient = new Nutrient();

        nutrient.setName("Protein");
        nutrient.setUnit("amino acid");
        nutrient.setDailyValue(5.0f);

        nutrientRepository.save(nutrient);
        System.out.println("✅ Nutrient seeding completed!");
    }
}
