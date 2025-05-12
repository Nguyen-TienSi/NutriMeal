import 'dart:convert';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
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
    try {
      return UserDetailData(
        id: json['id'] != null
            ? UuidValue.fromString(json['id'].toString())
            : null,
        userId: json['userId']?.toString(),
        name: json['name']?.toString(),
        email: json['email']?.toString(),
        pictureUrl: json['pictureUrl']?.toString(),
        authProvider: json['authProvider']?.toString(),
        gender: json['gender'] != null
            ? Gender.values.firstWhere(
                (element) =>
                    element.toString().split('.').last ==
                    json['gender'].toString(),
                orElse: () => Gender.other,
              )
            : null,
        dateOfBirth: json['dateOfBirth'] != null
            ? DateTime.tryParse(json['dateOfBirth'].toString())
            : null,
        activityLevel: json['activityLevel'] != null
            ? ActivityLevel.values.firstWhere(
                (element) =>
                    element.toString().split('.').last ==
                    json['activityLevel'].toString(),
                orElse: () => ActivityLevel.normal,
              )
            : null,
        healthGoal: json['healthGoal'] != null
            ? HealthGoal.values.firstWhere(
                (element) =>
                    element.toString().split('.').last ==
                    json['healthGoal'].toString().replaceAll('_', ''),
                orElse: () => HealthGoal.maintain,
              )
            : null,
        currentWeight: json['currentWeight'] != null
            ? int.tryParse(json['currentWeight'].toString())
            : null,
        targetWeight: json['targetWeight'] != null
            ? int.tryParse(json['targetWeight'].toString())
            : null,
        currentHeight: json['currentHeight'] != null
            ? int.tryParse(json['currentHeight'].toString())
            : null,
      );
    } catch (e) {
      debugPrint('Error parsing UserDetailData: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id?.toString() ?? '',
      'userId': userId ?? '',
      'name': name ?? '',
      'email': email ?? '',
      'pictureUrl': pictureUrl ?? '',
      'authProvider': authProvider ?? '',
      'gender': gender?.toString().split('.').last ?? '',
      'dateOfBirth': dateOfBirth?.toIso8601String() ?? '',
      'activityLevel': activityLevel?.toString().split('.').last ?? '',
      'healthGoal': healthGoal?.toString().split('.').last ?? '',
      'currentWeight': currentWeight,
      'targetWeight': targetWeight,
      'currentHeight': currentHeight,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
