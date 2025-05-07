import 'package:intl/intl.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:uuid/uuid_value.dart';

import 'package:nutriai_app/data/models/meal_log_detail_data.dart';
import 'package:nutriai_app/data/models/meal_log_summary_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';
import 'package:nutriai_app/exception/unnamed_exception.dart';
import 'package:flutter/foundation.dart';

class MealLogService {
  final ApiRepository _apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<List<MealLogSummaryData>> getMealLogSummaryDataList(
      DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/meal-logs/$formattedDate',
        fromJson: (data) {
          if (data is List) {
            return data.map((e) => MealLogSummaryData.fromJson(e)).toList();
          } else {
            throw UnnamedException('Invalid data format');
          }
        },
      );
    } catch (e) {
      debugPrint('Error fetching meal log detail: $e');
      return [];
    }
  }

  Future<MealLogDetailData?> getMealLogDetailData(UuidValue id) async {
    try {
      final data = await _apiRepository.fetchData<dynamic>(
        endPoint: '/meal-logs/search',
        params: {'id': id.toString()},
        fromJson: (data) => MealLogDetailData.fromJson(data),
      );
      return data;
    } catch (e) {
      debugPrint('Error fetching meal log detail: $e');
      return null;
    }
  }

  Future<List<RecipeSummaryData>> fetchRecipeSummaryListByMealLogId(
      UuidValue id) async {
    try {
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/meal-logs/$id/recipes',
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
}
