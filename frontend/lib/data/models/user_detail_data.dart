import 'dart:convert';
import 'package:uuid/uuid.dart';

import 'package:nutriai_app/utils/enums.dart';

class UserDetailData {
  UuidValue? id;
  String? userId;
  String? name;
  String? email;
  String? pictureUrl;
  String? authProvider;
  Gender? gender;
  DateTime? dateOfBirth;
  ActivityLevel? activityLevel;
  HealthGoal? healthGoal;
  int? currentWeight;
  int? targetWeight;
  int? currentHeight;

  UserDetailData({
    this.id,
    this.userId,
    this.name,
    this.email,
    this.pictureUrl,
    this.authProvider,
    this.gender,
    this.dateOfBirth,
    this.activityLevel,
    this.healthGoal,
    this.currentWeight,
    this.targetWeight,
    this.currentHeight,
  });

  factory UserDetailData.fromJson(Map<String, dynamic> json) {
    return UserDetailData(
      id: UuidValue.fromString(json['id'] as String),
      userId: json['userId'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      pictureUrl: json['pictureUrl'] as String,
      authProvider: json['authProvider'] as String,
      gender: Gender.values.firstWhere(
        (element) => element.toString() == 'Gender.${json['gender']}',
        orElse: () => Gender.other,
      ),
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      activityLevel: ActivityLevel.values.firstWhere(
        (element) =>
            element.toString() == 'ActivityLevel.${json['activityLevel']}',
        orElse: () => ActivityLevel.normal,
      ),
      healthGoal: HealthGoal.values.firstWhere(
        (element) => element.toString() == 'HealthGoal.${json['healthGoal']}',
        orElse: () => HealthGoal.maintain,
      ),
      currentWeight: json['currentWeight'] as int,
      targetWeight: json['targetWeight'] as int,
      currentHeight: json['currentHeight'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toString(),
      'userId': userId,
      'name': name,
      'email': email,
      'pictureUrl': pictureUrl,
      'authProvider': authProvider,
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
