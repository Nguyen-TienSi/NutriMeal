import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/utils/enums.dart';

class PersonalSummaryCard extends StatelessWidget {
  final UserDetailData userDetailData;
  const PersonalSummaryCard({super.key, required this.userDetailData});

  String getAge(DateTime? dob) {
    if (dob == null) return '';
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return '$age years old';
  }

  String getGoalString() {
    switch (userDetailData.healthGoal) {
      case HealthGoal.weightLoss:
        return 'Lose weight';
      case HealthGoal.weightGain:
        return 'Gain weight';
      case HealthGoal.maintain:
        return 'Maintain weight';
      default:
        return '-';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.all(16.r),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36.r,
                  backgroundColor: Colors.grey[100],
                  backgroundImage: userDetailData.pictureUrl != null &&
                          userDetailData.pictureUrl!.isNotEmpty
                      ? NetworkImage(userDetailData.pictureUrl!)
                      : null,
                  child: userDetailData.pictureUrl == null ||
                          userDetailData.pictureUrl!.isEmpty
                      ? Icon(Icons.person, size: 48.sp, color: Colors.grey[400])
                      : null,
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userDetailData.name ?? 'No Name',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        getAge(userDetailData.dateOfBirth),
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 18.h),
            Divider(height: 1.h, thickness: 1.h, color: Colors.grey[200]),
            SizedBox(height: 18.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current weight',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  userDetailData.currentWeight != null
                      ? '${userDetailData.currentWeight} kg'
                      : '-',
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Goal',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  getGoalString(),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
