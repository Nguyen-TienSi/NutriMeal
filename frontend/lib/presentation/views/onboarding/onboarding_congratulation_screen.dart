import 'package:flutter/material.dart';

import '../../layout/main_screen_layout.dart';

class OnboardingCongratulationScreen extends StatelessWidget {
  const OnboardingCongratulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => MainScreenLayout()),
                (Route<dynamic> route) => false,
              );
            },
            child: Text("Continue"),
          )
        ],
      ),
    );
  }
}
