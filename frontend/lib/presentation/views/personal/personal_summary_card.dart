import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
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
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFF8F5F0),
      elevation: 0,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: userDetailData.pictureUrl != null &&
                          userDetailData.pictureUrl!.isNotEmpty
                      ? NetworkImage(userDetailData.pictureUrl!)
                      : null,
                  child: userDetailData.pictureUrl == null ||
                          userDetailData.pictureUrl!.isEmpty
                      ? const Icon(Icons.person, size: 48, color: Colors.grey)
                      : null,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userDetailData.name ?? 'No Name',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Roboto',
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        getAge(userDetailData.dateOfBirth),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE6E1DA)),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Current weight',
                          style:
                              TextStyle(fontSize: 15, color: Colors.black54)),
                    ],
                  ),
                ),
                Text(
                  userDetailData.currentWeight != null
                      ? '${userDetailData.currentWeight} kg'
                      : '-',
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Goal',
                          style:
                              TextStyle(fontSize: 15, color: Colors.black54)),
                    ],
                  ),
                ),
                Text(
                  getGoalString(),
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
