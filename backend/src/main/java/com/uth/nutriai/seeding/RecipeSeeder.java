package com.uth.nutriai.seeding;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.uth.nutriai.model.domain.Recipe;
import com.uth.nutriai.model.enumeration.TimeOfDay;
import com.uth.nutriai.repository.IRecipeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.boot.CommandLineRunner;
import org.springframework.core.io.ClassPathResource;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Component
@RequiredArgsConstructor
public class RecipeSeeder implements CommandLineRunner {

    private final IRecipeRepository recipeRepository;
    private final ObjectMapper objectMapper;

    @Override
    public void run(String... args) throws Exception {
        if (recipeRepository.count() == 0) {
            seedRecipes();
        }
    }

    private void seedRecipes() throws IOException {
        List<Recipe> allRecipes = new ArrayList<>();
        int fileIndex = 1;

        ClassPathResource resource;
        while ((resource = new ClassPathResource("/data/recipes/recipes-" + fileIndex + ".json")).exists()) {
            try (InputStream inputStream = resource.getInputStream()) {
                List<Map<String, Object>> rawRecipes = objectMapper.readValue(
                        inputStream,
                        new TypeReference<>() {
                        }
                );

                List<Recipe> recipes = rawRecipes.stream().map(raw -> {
                    Recipe recipe = objectMapper.convertValue(raw.entrySet().stream()
                            .filter(e -> !e.getKey().equals("cookingTime") && !e.getKey().equals("timesOfDay"))
                            .collect(Collectors.toMap(Map.Entry::getKey, Map.Entry::getValue)), Recipe.class);

                    // Convert cooking time to Duration
                    if (raw.containsKey("cookingTime")) {
                        int minutes = (Integer) raw.get("cookingTime");
                        recipe.setCookingTime(Duration.ofMinutes(minutes));
                    }

                    // Convert timesOfDay strings to uppercase
                    if (raw.containsKey("timesOfDay")) {
                        @SuppressWarnings("unchecked")
                        List<String> times = (List<String>) raw.get("timesOfDay");
                        recipe.setTimesOfDay(null); // Clear any invalid enum values
                        List<TimeOfDay> timesOfDay = times.stream()
                                .map(String::toUpperCase)
                                .map(TimeOfDay::valueOf)
                                .collect(Collectors.toList());
                        recipe.setTimesOfDay(timesOfDay);
                    }

                    return recipe;
                }).toList();

                allRecipes.addAll(recipes);
                fileIndex++;
            } catch (IOException e) {
                throw new IOException("Error loading recipes file " + fileIndex, e);
            }
        }

        if (allRecipes.isEmpty()) {
            throw new IOException("Error loading recipes: No recipe files found");
        }

        recipeRepository.saveAll(allRecipes);
    }
}