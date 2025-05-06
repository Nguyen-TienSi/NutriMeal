import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/layout/main_screen_layout.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart'
    show AuthManager;
import 'package:nutriai_app/service/external-service/auth_provider.dart'
    show AuthProvider;

import 'social_login_button.dart' show SocialLoginButton;

class LoginBottomSheetButton extends StatelessWidget {
  const LoginBottomSheetButton({super.key});

  Future<void> _login(AuthProvider provider, BuildContext context) async {
    try {
      await AuthManager.signIn(provider);
      if (!context.mounted) return;
      if (AuthManager.isLoggedIn()) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MainScreenLayout(),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
        ),
        onTap: () => _showLoginBottomSheet(context),
      ),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16.0),
          height: 250,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Log in',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              SocialLoginButton(
                buttonText: 'Continue with Google',
                imagePath: 'assets/images/google_branding_logo.png',
                onPressed: () async {
                  await _login(AuthProvider.google, context);
                },
              ),
              SizedBox(height: 10),
              SocialLoginButton(
                buttonText: 'Continue with Facebook',
                imagePath: 'assets/images/facebook_branding_logo.png',
                onPressed: () async {
                  await _login(AuthProvider.facebook, context);
                },
              ),
              SizedBox(height: 20),
              Text.rich(
                TextSpan(
                  text: 'By continuing, you agree to NutriAI\'s ',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  children: [
                    TextSpan(
                      text: 'Terms & Conditions',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: ' and ',
                      style: TextStyle(color: Colors.grey),
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}
