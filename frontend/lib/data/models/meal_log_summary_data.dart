import 'dart:convert';

import 'package:nutriai_app/utils/enums.dart';
import 'package:uuid/uuid.dart';

class MealLogSummaryData {
  final UuidValue id;
  final TimeOfDay timeOfDay;
  final DateTime trackingDate;
  final double totalCalories;
  final double consumedCalories;

  MealLogSummaryData({
    required this.id,
    required this.timeOfDay,
    required this.trackingDate,
    required this.totalCalories,
    required this.consumedCalories,
  });

  factory MealLogSummaryData.fromJson(Map<String, dynamic> json) {
    return MealLogSummaryData(
      id: UuidValue.fromString(json['id']),
      timeOfDay: TimeOfDay.values.firstWhere(
        (e) => e.toString() == json['timeOfDay'],
        orElse: () => TimeOfDay.morning,
      ),
      trackingDate: DateTime.parse(json['trackingDate']),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      consumedCalories: (json['consumedCalories'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'timeOfDay': timeOfDay.toString(),
      'trackingDate': trackingDate.toIso8601String(),
      'totalCalories': totalCalories,
      'consumedCalories': consumedCalories,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
