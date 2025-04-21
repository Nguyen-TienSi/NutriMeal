import 'package:flutter/material.dart';
import 'package:nutriai_app/core/app_config.dart' show appName;
import 'package:nutriai_app/presentation/views/onboarding/onboarding_screen.dart'
    show OnboardingScreen;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: Colors.green,
          onPrimary: Colors.white,
        ),
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const OnboardingScreen(),
    );
  }
}
