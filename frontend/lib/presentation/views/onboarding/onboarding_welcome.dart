import 'package:flutter/material.dart';
import 'package:nutriai_app/core/app_config.dart';
import 'package:nutriai_app/presentation/views/auth/login_screen.dart'
    show LoginScreen;

class OnboardingWelcome extends StatelessWidget {
  const OnboardingWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Welcome to \n$appName",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Already have an account?"),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              child: const Text("Login"),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 4.0,
          runSpacing: 4.0,
          children: [
            const Text("By continuing, you agree to our"),
            const Text(
              "Terms of Service",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
            const Text("and"),
            const Text(
              "Privacy Policy",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
            ),
          ],
        ),
      ],
    );
  }
}
