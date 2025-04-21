import 'package:flutter/material.dart';

class MacronutrientsProgressSection extends StatelessWidget {
  const MacronutrientsProgressSection({super.key});

  final int _totalCalories = 93;
  final int _totalCarbs = 24;
  final int _totalProtein = 1;
  final int _totalFat = 0;

  final int _maxCalories = 2003;
  final int _maxCarbs = 250;
  final int _maxProtein = 100;
  final int _maxFat = 67;

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
                  '$_totalCalories / $_maxCalories kcal',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                )
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value: _totalCalories / _maxCalories,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 6,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroColumn(
                    'Carbs', _totalCarbs, _maxCarbs, Colors.orange),
                _buildMacroColumn(
                    'Protein', _totalProtein, _maxProtein, Colors.purple),
                _buildMacroColumn('Fat', _totalFat, _maxFat, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroColumn(String label, int current, int max, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: current / max,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 6,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '$current g / $max g',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}
