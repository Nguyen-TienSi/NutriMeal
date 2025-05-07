import 'dart:convert';

class NutrientData {
  final String name;
  final String unit;
  final double value;

  NutrientData({
    required this.name,
    required this.unit,
    required this.value,
  });

  factory NutrientData.fromJson(Map<String, dynamic> json) {
    return NutrientData(
      name: json['name'],
      unit: json['unit'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'value': value,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}
