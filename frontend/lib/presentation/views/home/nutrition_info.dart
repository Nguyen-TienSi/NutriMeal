import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          "${value.toInt()}/${goal.toInt()}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12.sp,
            color: Colors.grey,
          ),
        ),
        Text(
          nutrient,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
