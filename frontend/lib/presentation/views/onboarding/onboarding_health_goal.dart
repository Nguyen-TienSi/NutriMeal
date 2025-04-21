import 'package:flutter/material.dart';

class OnboardingHealthGoal extends StatefulWidget {
  const OnboardingHealthGoal({super.key});

  @override
  State<OnboardingHealthGoal> createState() => _State();
}

class _State extends State<OnboardingHealthGoal> {
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
    return Column(
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
      ],
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
