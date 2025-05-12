import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingAdditionalHealthGoals extends StatefulWidget {
  const OnboardingAdditionalHealthGoals({super.key});

  @override
  State<OnboardingAdditionalHealthGoals> createState() =>
      _OnboardingAdditionalHealthGoalsState();
}

class _OnboardingAdditionalHealthGoalsState
    extends State<OnboardingAdditionalHealthGoals> {
  final List<String> _selectedGoals = [];

  final List<String> _healthGoals = [
    "Living longer",
    "Feeling energized",
    "Optimize athletic performance",
    "Build healthier habits",
    "Eliminate All-or-Nothing mindset",
    "Prevent lifestyle diseases",
  ];

  void _toggleGoalSelection(String goalName) {
    setState(() {
      _selectedGoals.contains(goalName)
          ? _selectedGoals.remove(goalName)
          : _selectedGoals.add(goalName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'What additional goals do you have?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ..._healthGoals.map((goal) => HealthGoalCard(
              goalName: goal,
              isSelected: _selectedGoals.contains(goal),
              onTap: () => _toggleGoalSelection(goal),
            )),
      ],
    );
  }
}

class HealthGoalCard extends StatelessWidget {
  final String goalName;
  final bool isSelected;
  final VoidCallback onTap;

  const HealthGoalCard({
    required this.goalName,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        width: double.infinity,
        child: Card(
          color: isSelected ? Colors.green : Colors.white,
          child: Padding(
            padding: EdgeInsets.all(16.h),
            child: Text(
              goalName,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
