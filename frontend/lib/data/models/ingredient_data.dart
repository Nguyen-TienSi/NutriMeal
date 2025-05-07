import 'dart:convert';

class IngredientData {
  final String name;
  final String unit;
  final double quantity;

  IngredientData(
      {required this.name, required this.unit, required this.quantity});

  factory IngredientData.fromJson(Map<String, dynamic> json) {
    return IngredientData(
      name: json['name'],
      unit: json['unit'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'quantity': quantity,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
