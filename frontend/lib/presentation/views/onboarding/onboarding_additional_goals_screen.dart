import 'package:flutter/material.dart';

import 'onboarding_gender_screen.dart';

class OnboardingAdditionalGoalsScreen extends StatefulWidget {
  const OnboardingAdditionalGoalsScreen({super.key});

  @override
  State<OnboardingAdditionalGoalsScreen> createState() => _State();
}

class _State extends State<OnboardingAdditionalGoalsScreen> {
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'What additional goals do you have?',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            _goalCard("Living longer"),
            _goalCard("Feeling energized"),
            _goalCard("Optimize athletic performance"),
            _goalCard("Build healthier habits"),
            _goalCard("Eliminate All-or-Nothing mindset"),
            _goalCard("Prevent lifestyle diseases"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingGenderScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Next",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _goalCard(String goalName) {
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
