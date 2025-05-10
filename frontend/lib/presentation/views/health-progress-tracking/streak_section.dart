import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/streak_data.dart';

class StreakSection extends StatelessWidget {
  final StreakData streakData;

  const StreakSection({super.key, required this.streakData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _StreakItem(
              label: 'Current Streak',
              value: streakData.currentStreak ?? 0,
            ),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey.withValues(),
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
      children: [
        Text(
          '$value days',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
