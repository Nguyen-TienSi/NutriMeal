import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesChart extends StatelessWidget {
  final double consumedCalories;
  final double totalCalories;

  const CaloriesChart({
    super.key,
    required this.consumedCalories,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    double percent = totalCalories != 0
        ? (consumedCalories / totalCalories).clamp(0.0, 1.0)
        : 0.0;

    return Center(
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 12.0,
        percent: percent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$consumedCalories / $totalCalories",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const Text("Kcal",
                style: TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        progressColor: Colors.green,
        backgroundColor: Colors.grey[300]!,
      ),
    );
  }
}
