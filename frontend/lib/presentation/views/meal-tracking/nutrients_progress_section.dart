import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/meal_log_detail_data.dart';

class NutrientsProgressSection extends StatelessWidget {
  final MealLogDetailData mealLogDetailData;

  const NutrientsProgressSection({super.key, required this.mealLogDetailData});

  double get _totalCalories => mealLogDetailData.consumedCalories;
  double get _maxCalories => mealLogDetailData.totalCalories;

  double _getConsumedNutrientValue(String name) {
    try {
      return mealLogDetailData.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name)
          .value;
    } catch (e) {
      return 0.0;
    }
  }

  double _getTotalNutrientValue(String name) {
    try {
      return mealLogDetailData.totalNutrients
          .firstWhere((nutrient) => nutrient.name == name)
          .value;
    } catch (e) {
      return 0.0;
    }
  }

  String _getNutrientUnit(String name) {
    try {
      return mealLogDetailData.consumedNutrients
          .firstWhere((nutrient) => nutrient.name == name)
          .unit;
    } catch (e) {
      return 'g';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            SizedBox(height: 20.h),
            Row(
              children: [
                Text(
                  'Daily intake',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
                const Spacer(),
                Text(
                  '${_totalCalories.toInt()} / ${_maxCalories.toInt()} kcal',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                )
              ],
            ),
            SizedBox(height: 6.h),
            LinearProgressIndicator(
              value: _maxCalories > 0 ? _totalCalories / _maxCalories : 0,
              backgroundColor: Colors.grey[300],
              color: Colors.green,
              minHeight: 6.h,
            ),
            SizedBox(height: 16.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMacroColumn(
                    'Carbs',
                    _getNutrientUnit('Carbohydrate'),
                    _getConsumedNutrientValue('Carbohydrate'),
                    _getTotalNutrientValue('Carbohydrate'),
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
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 70.w,
          child: LinearProgressIndicator(
            value: max != 0 ? current / max : 0,
            color: color,
            backgroundColor: Colors.grey[300],
            minHeight: 6.h,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          '${current.toInt()}/${max.toInt()}',
          style: TextStyle(fontSize: 12.sp, color: Colors.grey),
        ),
        Text(
          unit,
          style: TextStyle(fontSize: 10.sp, color: Colors.grey),
        ),
      ],
    );
  }
}
