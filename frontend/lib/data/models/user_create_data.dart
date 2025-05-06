import 'dart:convert';

import 'package:nutriai_app/utils/enums.dart';

class UserCreateData {
  Gender? gender = Gender.other;
  DateTime? dateOfBirth;
  ActivityLevel? activityLevel;
  HealthGoal? healthGoal;
  int? currentWeight;
  int? targetWeight;
  int? currentHeight;

  void clear() {
    gender = Gender.other;
    dateOfBirth = null;
    activityLevel = null;
    healthGoal = null;
    currentWeight = null;
    targetWeight = null;
    currentHeight = null;
  }

  Map<String, dynamic> toJson() {
    return {
      'gender': gender?.toString().split('.').last,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'activityLevel': activityLevel?.toString().split('.').last,
      'healthGoal': healthGoal?.toString().split('.').last,
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'currentHeight': currentHeight,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
