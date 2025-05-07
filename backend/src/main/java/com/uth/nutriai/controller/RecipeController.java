package com.uth.nutriai.controller;

import com.uth.nutriai.dto.request.RecipeCreateDto;
import com.uth.nutriai.dto.request.RecipeUpdateDto;
import com.uth.nutriai.dto.response.ApiResponse;
import com.uth.nutriai.dto.response.RecipeDetailDto;
import com.uth.nutriai.dto.response.RecipeSummaryDto;
import com.uth.nutriai.service.IRecipeService;
import com.uth.nutriai.utils.ObjectDataTypeParser;
import jakarta.validation.Valid;
import lombok.AllArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.net.URI;
import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping(value = "/api/recipes", produces = "application/vnd.company.app-v1+json")
@AllArgsConstructor
public class RecipeController {

    private IRecipeService recipeService;

    @GetMapping
    public ResponseEntity<ApiResponse<List<RecipeSummaryDto>>> findAllRecipes() {
        List<RecipeSummaryDto> recipeDetailDtoList = recipeService.findAllRecipes();
        if (recipeDetailDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<RecipeSummaryDto>> response = new ApiResponse<>(recipeDetailDtoList);
        return ResponseEntity.ok(response);
    }

    @RequestMapping(value = "/{id}", method = {RequestMethod.GET, RequestMethod.HEAD})
    public ResponseEntity<ApiResponse<RecipeDetailDto>> findRecipeById(
            @PathVariable("id") UUID id,
            @RequestHeader(value = "If-None-Match", required = false) String eTag
    ) {
        if (id == null) {
            return ResponseEntity.badRequest().build();
        }

        if (!recipeService.isRecipeAvailable(id)) {
            return ResponseEntity.notFound().build();
        }

        if (eTag != null && eTag.equals(recipeService.currentEtag(id))) {
            return ResponseEntity.status(HttpStatus.NOT_MODIFIED).build();
        }

        RecipeDetailDto recipeDetailDto = recipeService.findRecipeById(id);

        ApiResponse<RecipeDetailDto> response = new ApiResponse<>(recipeDetailDto);
        return ResponseEntity.ok()
                .eTag(recipeService.currentEtag(id))
                .body(response);
    }

    @RequestMapping(value = "/search/{keyword}/{value}", method = {RequestMethod.GET})
    public ResponseEntity<ApiResponse<List<RecipeSummaryDto>>> findRecipesByKeyword(
            @PathVariable("keyword") String fieldName,
            @PathVariable("value") String fieldValue
    ) {
        if (fieldName == null || fieldName.isBlank()) {
            return ResponseEntity.badRequest().build();
        }

        Object parsedValue = ObjectDataTypeParser.parse(fieldValue);
        if (!recipeService.isRecipeAvailable(fieldName, parsedValue)) {
            return ResponseEntity.notFound().build();
        }

        List<RecipeSummaryDto> recipeSummaryDtoList = recipeService.findRecipesByField(fieldName, parsedValue);
        if (recipeSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<RecipeSummaryDto>> response = new ApiResponse<>(recipeSummaryDtoList);
        return ResponseEntity.ok(response);
    }

    @PostMapping
    public ResponseEntity<ApiResponse<RecipeDetailDto>> createRecipe(
            @Valid @RequestBody RecipeCreateDto recipeCreateDto) {
        RecipeDetailDto recipeDetailDto = recipeService.createRecipe(recipeCreateDto);
        URI location = URI.create("/api/recipes/" + recipeDetailDto.id());
        ApiResponse<RecipeDetailDto> response = new ApiResponse<>(recipeDetailDto);
        return ResponseEntity.created(location)
                .eTag(recipeService.currentEtag(recipeDetailDto.id()))
                .body(response);
    }

    @PutMapping
    public ResponseEntity<ApiResponse<RecipeDetailDto>> updateRecipe(
            @Valid @RequestBody RecipeUpdateDto recipeUpdateDto,
            @RequestHeader(value = "If-Match", required = false) String eTag
    ) {

        if (!recipeService.isRecipeAvailable(recipeUpdateDto.id())) {
            return ResponseEntity.notFound().build();
        }

        if (eTag == null || !eTag.equals(recipeService.currentEtag(recipeUpdateDto.id()))) {
            return ResponseEntity.status(HttpStatus.PRECONDITION_FAILED).build();
        }

        RecipeDetailDto recipeDetailDto = recipeService.updateRecipe(recipeUpdateDto);
        ApiResponse<RecipeDetailDto> response = new ApiResponse<>(recipeDetailDto);
        return ResponseEntity.ok()
                .eTag(recipeService.currentEtag(recipeDetailDto.id()))
                .body(response);
    }

    @DeleteMapping
    public ResponseEntity<Void> deleteRecipe(
            @RequestParam UUID id,
            @RequestHeader(value = "If-Match", required = false) String eTag
    ) {

        if (!recipeService.isRecipeAvailable(id)) {
            return ResponseEntity.notFound().build();
        }

        if (eTag == null || !eTag.equals(recipeService.currentEtag(id))) {
            return ResponseEntity.status(HttpStatus.PRECONDITION_FAILED).build();
        }

        recipeService.deleteRecipe(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/meal-time/{mealTime}")
    public ResponseEntity<ApiResponse<List<RecipeSummaryDto>>> findRecipesByMealTime(@PathVariable("mealTime") String mealTime) {
        List<RecipeSummaryDto> recipeSummaryDtoList = recipeService.findRecipesByMealTime(mealTime);
        if (recipeSummaryDtoList.isEmpty()) {
            return ResponseEntity.noContent().build();
        }
        ApiResponse<List<RecipeSummaryDto>> response = new ApiResponse<>(recipeSummaryDtoList);
        return ResponseEntity.ok(response);
    }
}
