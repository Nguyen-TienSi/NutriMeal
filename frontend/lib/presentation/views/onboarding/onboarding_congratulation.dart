import 'package:flutter/material.dart';

class OnboardingCongratulation extends StatelessWidget {
  const OnboardingCongratulation({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.check_circle,
          size: 100,
          color: Colors.green,
        ),
        Text(
          "Congratulations! You have completed the onboarding process.",
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
