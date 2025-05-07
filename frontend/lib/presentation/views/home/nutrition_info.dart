import 'package:flutter/material.dart';

class NutritionInfo extends StatelessWidget {
  final String nutrient;
  final double value;
  final double goal;
  final String unit;

  const NutritionInfo({
    super.key,
    required this.nutrient,
    required this.value,
    required this.goal,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return _buildNutritionItem(nutrient, value, goal);
  }

  Widget _buildNutritionItem(String nutrient, double value, double goal) {
    return Column(
      children: [
        Text(
          "$value/$goal $unit",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(nutrient,
            style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
