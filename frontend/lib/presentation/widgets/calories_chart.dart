import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesChart extends StatelessWidget {
  final int calories;
  final int goalCalories;

  const CaloriesChart({
    super.key,
    required this.calories,
    this.goalCalories = 2000, // Mặc định mục tiêu là 2000 Kcal
  });

  @override
  Widget build(BuildContext context) {
    double percent = (calories / goalCalories).clamp(0.0, 1.0);

    return Center(
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 12.0,
        percent: percent,
        center: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$calories / $goalCalories",
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
