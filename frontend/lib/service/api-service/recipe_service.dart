import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/recipe_detail_data.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';
import 'package:nutriai_app/exception/unnamed_exception.dart';
import 'package:uuid/uuid_value.dart';

class RecipeService {
  final ApiRepository _apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<List<RecipeSummaryData>> fetchRecipeSummaryListByMealTime({
    required String mealTime,
    int pageNumber = 0,
    int pageSize = -1,
  }) async {
    try {
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/recipes/meal-time/$mealTime',
        params: {
          'pageNumber': pageNumber.toString(),
          'pageSize': pageSize.toString()
        },
        fromJson: (data) {
          if (data is List) {
            return data
                .map((item) => RecipeSummaryData.fromJson(item))
                .toList();
          } else {
            throw UnnamedException('Invalid data format');
          }
        },
      );
    } catch (e) {
      debugPrint('Error fetching recipe summary list: $e');
      return [];
    }
  }

  Future<List<RecipeSummaryData>> searchRecipeSummaryList({
    String keyword = 'recipeName',
    required dynamic value,
  }) async {
    try {
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/recipes/search/$keyword/$value',
        fromJson: (data) {
          if (data is List) {
            return data
                .map((item) => RecipeSummaryData.fromJson(item))
                .toList();
          } else {
            throw UnnamedException('Invalid data format');
          }
        },
      );
    } catch (e) {
      debugPrint('Error searching recipe summary list: $e');
      return [];
    }
  }

  Future<RecipeDetailData?> getRecipeDetail(UuidValue id) async {
    try {
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/recipes/${id.toString()}',
        fromJson: (data) {
          debugPrint('Received data: $data');
          return RecipeDetailData.fromJson(data);
        },
      );
    } catch (e) {
      debugPrint('Error fetching recipe detail: $e');
      return null;
    }
  }
}
