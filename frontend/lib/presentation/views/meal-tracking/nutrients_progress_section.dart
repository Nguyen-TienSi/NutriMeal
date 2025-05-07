import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/meal_log_detail_data.dart';

class NutrientsProgressSection extends StatelessWidget {
  final MealLogDetailData mealLogDetailData;

  const NutrientsProgressSection({super.key, required this.mealLogDetailData});

  double get _totalCalories => mealLogDetailData.consumedCalories;
  double get _maxCalories => mealLogDetailData.totalCalories;
  double _getConsumedNutrientValue(String name) =>
      mealLogDetailData.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name,
              orElse: () => throw Exception('Nutrient not found: $name'))
          .value;
  double _getTotalNutrientValue(String name) => mealLogDetailData.totalNutrients
      .firstWhere((nutrient) => nutrient.name == name,
          orElse: () => throw Exception('Nutrient not found: $name'))
      .value;
  String _getNutrientUnit(String name) => mealLogDetailData.consumedNutrients
      .firstWhere((nutrient) => nutrient.name == name,
          orElse: () => throw Exception('Nutrient not found: $name'))
      .unit;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Daily intake',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_totalCalories.toInt()} / ${_maxCalories.toInt()} kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: _totalCalories /
                  _maxCalories, // Ensure this is between 0 and 1
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 6,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroColumn(
                    'Carbs',
                    _getNutrientUnit('Carbohydrates'),
                    _getConsumedNutrientValue('Carbohydrates'),
                    _getTotalNutrientValue('Carbohydrates'),
                    Colors.orange),
                _buildMacroColumn(
                    'Protein',
                    _getNutrientUnit('Protein'),
                    _getConsumedNutrientValue('Protein'),
                    _getTotalNutrientValue('Protein'),
                    Colors.purple),
                _buildMacroColumn(
                    'Fat',
                    _getNutrientUnit('Fat'),
                    _getConsumedNutrientValue('Fat'),
                    _getTotalNutrientValue('Fat'),
                    Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroColumn(String nutrientName, String unit, double current,
      double max, Color color) {
    return Column(
      children: [
        Text(
          nutrientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: max != 0 ? current / max : 0,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$current $unit / $max $unit',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
