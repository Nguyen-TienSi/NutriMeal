import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:nutriai_app/data/models/nutrient_data.dart';
import 'package:nutriai_app/utils/enums.dart';

class MealLogDetailData {
  final UuidValue id;
  final TimeOfDay timeOfDay;
  final DateTime trackingDate;
  final double totalCalories;
  final double consumedCalories;
  final List<NutrientData> consumedNutrients;
  final List<NutrientData> totalNutrients;

  MealLogDetailData({
    required this.id,
    required this.timeOfDay,
    required this.trackingDate,
    required this.totalCalories,
    required this.consumedCalories,
    required this.consumedNutrients,
    required this.totalNutrients,
  });

  factory MealLogDetailData.fromJson(Map<String, dynamic> json) {
    return MealLogDetailData(
      id: UuidValue.fromString(json['id']),
      timeOfDay: TimeOfDay.values.firstWhere(
        (e) => e.toString() == json['timeOfDay'],
        orElse: () => TimeOfDay.morning,
      ),
      trackingDate: DateTime.parse(json['trackingDate']),
      totalCalories: json['totalCalories'],
      consumedCalories: json['consumedCalories'],
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
      'timeOfDay': timeOfDay.toString(),
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
