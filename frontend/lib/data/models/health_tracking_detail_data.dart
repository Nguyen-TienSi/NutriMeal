import 'dart:convert';

import 'package:nutriai_app/data/models/nutrient_data.dart';
import 'package:uuid/uuid.dart';

class HealthTrackingDetailData {
  final UuidValue id;
  final DateTime trackingDate;
  final double totalCalories;
  final double consumedCalories;
  final List<NutrientData> consumedNutrients;
  final List<NutrientData> totalNutrients;

  HealthTrackingDetailData({
    required this.id,
    required this.trackingDate,
    required this.totalCalories,
    required this.consumedCalories,
    required this.consumedNutrients,
    required this.totalNutrients,
  });

  factory HealthTrackingDetailData.fromJson(Map<String, dynamic> json) {
    return HealthTrackingDetailData(
      id: UuidValue.fromString(json['id']),
      trackingDate: DateTime.parse(json['trackingDate']),
      totalCalories: json['totalCalories'].toDouble(),
      consumedCalories: json['consumedCalories'].toDouble(),
      consumedNutrients: (json['consumedNutrients'] as List<dynamic>)
          .map((e) => NutrientData.fromJson(e))
          .cast<NutrientData>()
          .toList(),
      totalNutrients: (json['totalNutrients'] as List<dynamic>)
          .map((e) => NutrientData.fromJson(e))
          .cast<NutrientData>()
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'trackingDate': trackingDate.toIso8601String(),
      'totalCalories': totalCalories,
      'consumedCalories': consumedCalories,
      'consumedNutrients': consumedNutrients.map((e) => e.toJson()).toList(),
      'totalNutrients': totalNutrients.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
