import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/utils/enums.dart';

class OnboardingHealthGoal extends StatefulWidget {
  final UserCreateData userCreateData;

  const OnboardingHealthGoal({super.key, required this.userCreateData});

  @override
  State<OnboardingHealthGoal> createState() => _OnboardingHealthGoalState();
}

class _OnboardingHealthGoalState extends State<OnboardingHealthGoal> {
  HealthGoal? _selectedGoal;

  void _selectGoal(HealthGoal goal) {
    setState(() {
      _selectedGoal = goal;
      widget.userCreateData.healthGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          "What goal do you have in mind?",
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ...HealthGoal.values.map((goal) => _goalCard(goal)),
      ],
    );
  }

  Widget _goalCard(HealthGoal goal) {
    final isSelected = _selectedGoal == goal;
    final goalName = _getGoalName(goal);

    return GestureDetector(
      onTap: () => _selectGoal(goal),
      child: Card(
        color: isSelected ? Colors.green : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            goalName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  String _getGoalName(HealthGoal goal) {
    return switch (goal) {
      HealthGoal.weightLoss => 'Lose Weight',
      HealthGoal.maintain => 'Maintain Weight',
      HealthGoal.weightGain => 'Gain Weight',
    };
  }
}
