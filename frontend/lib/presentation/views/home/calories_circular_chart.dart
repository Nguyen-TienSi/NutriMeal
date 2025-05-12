import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloriesCircularChart extends StatelessWidget {
  final double consumedCalories;
  final double totalCalories;

  const CaloriesCircularChart({
    super.key,
    required this.consumedCalories,
    required this.totalCalories,
  });

  @override
  Widget build(BuildContext context) {
    double percent = totalCalories != 0
        ? (consumedCalories / totalCalories).clamp(0.0, 1.0)
        : 0.0;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularPercentIndicator(
          radius: 80.0,
          lineWidth: 20.0,
          percent: percent,
          center: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${consumedCalories.toInt()} / ${totalCalories.toInt()}",
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
              ),
              Text("Kcal",
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
            ],
          ),
          progressColor: Colors.green,
          backgroundColor: Colors.grey[300]!,
        ),
      ),
    );
  }
}
