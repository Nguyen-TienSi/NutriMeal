import 'dart:convert';

import 'package:uuid/uuid.dart';

class RecipeSummaryData {
  final UuidValue? id;
  final String recipeName;
  final String imageUrl;
  // final double? serving;
  // final String? servingUnit;
  final String calories;

  RecipeSummaryData({
    this.id,
    required this.recipeName,
    required this.imageUrl,
    // this.serving,
    // this.servingUnit,
    required this.calories,
  });

  factory RecipeSummaryData.fromJson(Map<String, dynamic> json) {
    return RecipeSummaryData(
      id: UuidValue.fromString(json['id'] as String),
      recipeName: json['recipeName'] as String,
      imageUrl: json['imageUrl'] as String,
      // serving: json['serving'] as double?,
      // servingUnit: json['servingUnit'] as String?,
      calories: json['calories'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recipeName': recipeName,
      'imageUrl': imageUrl,
      // 'serving': serving,
      // 'servingUnit': servingUnit,
      'calories': calories,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
