import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:nutriai_app/data/models/health_tracking_detail_data.dart';
import 'package:nutriai_app/data/repositories/api_repository.dart';
import 'package:nutriai_app/data/repositories/http_api_provider.dart';

class HealthTrackingService {
  final ApiRepository _apiRepository =
      ApiRepository(apiProvider: HttpApiProvider());

  Future<HealthTrackingDetailData?> getHealthTrackingDetailData(
      DateTime date) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(date);
      return await _apiRepository.fetchData<dynamic>(
        endPoint: '/health-tracking/$formattedDate',
        fromJson: (data) => HealthTrackingDetailData.fromJson(data),
      );
    } catch (e) {
      debugPrint("Error fetching health tracking detail: $e");
      return null;
    }
  }
}
