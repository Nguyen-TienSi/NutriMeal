import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/streak_data.dart';

class StreakSection extends StatelessWidget {
  final StreakData streakData;

  const StreakSection({super.key, required this.streakData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StreakItem(
              label: 'Current Streak',
              value: streakData.currentStreak ?? 0,
            ),
            Container(
              width: 1.w,
              height: 40.h,
              color: Colors.grey,
            ),
            _StreakItem(
              label: 'Longest Streak',
              value: streakData.longestStreak ?? 0,
            ),
          ],
        ),
      ),
    );
  }
}

class _StreakItem extends StatelessWidget {
  final String label;
  final int value;
  const _StreakItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              '$value ${value == 1 ? 'day' : 'days'}',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Icon(
              Icons.local_fire_department,
              size: 30.h,
              color: Colors.orangeAccent,
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
