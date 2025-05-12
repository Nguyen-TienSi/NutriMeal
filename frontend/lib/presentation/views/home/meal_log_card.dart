import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MealLogCard extends StatelessWidget {
  final String mealName;
  final String kcalRange;
  final String imagePath;
  final VoidCallback onTap;

  const MealLogCard({
    super.key,
    required this.mealName,
    required this.kcalRange,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.grey.withValues(alpha: 1),
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          mealName,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Recommended $kcalRange kcal",
          style: TextStyle(fontSize: 14.sp, color: Colors.grey),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.add_circle_outline,
            color: Colors.grey,
            size: 30.h,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }
}
