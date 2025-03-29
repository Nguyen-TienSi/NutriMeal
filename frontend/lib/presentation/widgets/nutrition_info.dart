import 'package:flutter/material.dart';

class NutritionInfo extends StatelessWidget {
  final int carbs, protein, fat;

  const NutritionInfo(
      {super.key,
      required this.carbs,
      required this.protein,
      required this.fat});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionItem("Carbs", carbs, 300),
        _buildNutritionItem("Protein", protein, 250),
        _buildNutritionItem("Fat", fat, 50),
      ],
    );
  }

  Widget _buildNutritionItem(String label, int value, int goal) {
    return Column(
      children: [
        Text(
          "$value/$goal g",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}
