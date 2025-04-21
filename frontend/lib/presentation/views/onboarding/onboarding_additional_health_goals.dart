import 'package:flutter/material.dart';

class OnboardingAdditionalHealthGoals extends StatefulWidget {
  const OnboardingAdditionalHealthGoals({super.key});

  @override
  State<OnboardingAdditionalHealthGoals> createState() => _State();
}

class _State extends State<OnboardingAdditionalHealthGoals> {
  final List<String?> _selectedGoals = [];

  void _selectGoal(String goalName) {
    setState(() {
      if (_selectedGoals.contains(goalName)) {
        _selectedGoals.remove(goalName);
      } else {
        _selectedGoals.add(goalName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'What additional goals do you have?',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        _healthGoalCard("Living longer"),
        _healthGoalCard("Feeling energized"),
        _healthGoalCard("Optimize athletic performance"),
        _healthGoalCard("Build healthier habits"),
        _healthGoalCard("Eliminate All-or-Nothing mindset"),
        _healthGoalCard("Prevent lifestyle diseases"),
      ],
    );
  }

  Widget _healthGoalCard(String goalName) {
    return GestureDetector(
      onTap: () => _selectGoal(goalName),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        width: double.infinity,
        child: Card(
          color:
              _selectedGoals.contains(goalName) ? Colors.green : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              goalName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _selectedGoals.contains(goalName)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
