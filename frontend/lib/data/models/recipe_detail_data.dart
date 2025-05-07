import 'dart:convert';

import 'package:nutriai_app/utils/enums.dart';
import 'package:uuid/uuid.dart';

import 'food_tag_data.dart';
import 'ingredient_data.dart';
import 'nutrient_data.dart';

class RecipeDetailData {
  RecipeDetailData({
    required this.id,
    required this.recipeName,
    required this.description,
    required this.instructions,
    required this.imageUrl,
    required this.cookingTime,
    required this.serving,
    required this.servingUnit,
    required this.ingredients,
    required this.foodTags,
    required this.nutrients,
    required this.timesOfDay,
  });

  final UuidValue id;
  final String recipeName;
  final String description;
  final String instructions;
  final String imageUrl;
  final int cookingTime;
  final double serving;
  final String servingUnit;

  final List<IngredientData> ingredients;
  final List<FoodTagData> foodTags;
  final List<NutrientData> nutrients;

  final List<TimeOfDay> timesOfDay;

  factory RecipeDetailData.fromJson(Map<String, dynamic> json) {
    return RecipeDetailData(
      id: UuidValue.fromString(json['id'] as String),
      recipeName: json['recipeName'] as String,
      description: json['description'] as String,
      instructions: json['instructions'] as String,
      imageUrl: json['imageUrl'] as String,
      cookingTime: json['cookingTime'] as int,
      serving: (json['serving'] as num).toDouble(),
      servingUnit: json['servingUnit'] as String,
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => IngredientData.fromJson(e))
              .cast<IngredientData>()
              .toList() ??
          [],
      foodTags: (json['foodTags'] as List<dynamic>?)
              ?.map((e) => FoodTagData.fromJson(e))
              .cast<FoodTagData>()
              .toList() ??
          [],
      nutrients: (json['nutrients'] as List<dynamic>?)
              ?.map((e) => NutrientData.fromJson(e))
              .cast<NutrientData>()
              .toList() ??
          [],
      timesOfDay: (json['timesOfDay'] as List<dynamic>)
          .map((e) => TimeOfDay.values.firstWhere(
                (element) => element.toString() == e,
                orElse: () => TimeOfDay.morning,
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id.toString(),
      'recipeName': recipeName,
      'description': description,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'cookingTime': cookingTime,
      'serving': serving,
      'servingUnit': servingUnit,
      'ingredients': ingredients.map((e) => e.toJson()).toList(),
      'foodTags': foodTags.map((e) => e.toJson()).toList(),
      'nutrients': nutrients.map((e) => e.toJson()).toList(),
      'timesOfDay': timesOfDay.map((e) => e.name).toList(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
