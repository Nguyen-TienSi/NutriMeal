import 'package:flutter/material.dart';

import 'onboarding_additional_goals_screen.dart';

class OnboardingGoalScreen extends StatefulWidget {
  const OnboardingGoalScreen({super.key});

  @override
  State<OnboardingGoalScreen> createState() => _State();
}

class _State extends State<OnboardingGoalScreen> {
  late bool _isSelectedGoal;
  String? _goalName;

  void _selectGoal(String goalName) {
    setState(() {
      _isSelectedGoal = true;
      _goalName = goalName;
    });
  }

  @override
  void initState() {
    super.initState();
    _isSelectedGoal = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "What goal do you have in mind?",
              style: TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            _goalCard('Lose Weight'),
            _goalCard('Maintain Weight'),
            _goalCard('Gain Weight'),
            ElevatedButton(
              onPressed: _isSelectedGoal
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OnboardingAdditionalGoalsScreen(),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSelectedGoal ? Colors.green : Colors.grey,
              ),
              child: Text(
                "Next",
                style: TextStyle(
                  color: _isSelectedGoal ? Colors.white : Colors.grey,
                ),
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
      child: Card(
        color: _isSelectedGoal && _goalName == goalName
            ? Colors.green
            : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            goalName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _isSelectedGoal && _goalName == goalName
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
