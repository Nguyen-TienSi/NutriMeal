import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/data/models/recipe_summary_data.dart';
import 'package:nutriai_app/data/models/streak_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';
import 'package:nutriai_app/exception/unnamed_exception.dart';

class StatisticService {
  final ApiRepository apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<List<RecipeSummaryData>> getFavoriteRecipeList() async {
    try {
      return await apiRepository.fetchData<dynamic>(
        endPoint: '/statistics/favorite-recipes',
        fromJson: (json) {
          if (json is List) {
            return json
                .map((item) => RecipeSummaryData.fromJson(item))
                .toList();
          } else {
            throw UnnamedException('Invalid data format');
          }
        },
      );
    } catch (e) {
      debugPrint('Error fetching favorite recipe list: $e');
      return [];
    }
  }

  Future<StreakData> getStreakData() async {
    try {
      return await apiRepository.fetchData<dynamic>(
          endPoint: '/statistics/streaks',
          fromJson: (json) => StreakData.fromJson(json));
    } catch (e) {
      debugPrint('Error fetching streak data: $e');
      return StreakData(currentStreak: 0, longestStreak: 0);
    }
  }

  Future<List<HealthTrackingDetailData>>
      getHealthTrackingDetailDataBetweenDates() async {
    try {
      return await apiRepository.fetchData<dynamic>(
          endPoint: '/statistics/current-month/health-tracking',
          fromJson: (json) {
            if (json is List) {
              return json
                  .map((item) => HealthTrackingDetailData.fromJson(item))
                  .toList();
            } else {
              throw UnnamedException('Invalid data format');
            }
          });
    } catch (e) {
      debugPrint('Error fetching health tracking detail data: $e');
      return [];
    }
  }
}
