import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/views/onboarding/setup_gender_screen.dart';
import 'package:nutriai_app/presentation/views/onboarding/setup_weight_screen.dart';

import '../../utils/constants.dart';
import 'main_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const OnboardingWeightScreen(),
    );
  }
}
