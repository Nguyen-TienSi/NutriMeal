import 'package:flutter/material.dart';

import '../views/onboarding/onboarding_welcome_screen.dart';
import '../../core/app_config.dart';

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
      home: const OnboardingWelcomeScreen(),
    );
  }
}
