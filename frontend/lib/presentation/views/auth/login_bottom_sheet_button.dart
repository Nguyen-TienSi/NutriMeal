import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/presentation/layout/main_screen_layout.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart'
    show AuthManager;
import 'package:nutriai_app/service/external-service/auth_provider.dart'
    show AuthProvider;
import 'package:nutriai_app/service/external-service/notification_service.dart';

import 'social_login_button.dart' show SocialLoginButton;

class LoginBottomSheetButton extends StatelessWidget {
  const LoginBottomSheetButton({super.key});

  Future<void> _login(AuthProvider provider, BuildContext context) async {
    try {
      await AuthManager.signIn(provider);
      if (AuthManager.isLoggedIn()) {
        await NotificationService().loginUserToOnesignal(null);
        if (!context.mounted) return;
        _navigateToMainScreen(context);
      } else {
        if (!context.mounted) return;
        _showSnackBar(context, 'Login failed. Please try again.');
      }
    } catch (error) {
      if (!context.mounted) return;
      _showSnackBar(context, 'An error occurred: $error');
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

  void _navigateToMainScreen(BuildContext context) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => MainScreenLayout(),
    ));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showLoginBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16.0.w,
            right: 16.0.w,
            top: 16.0.w,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0.w,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Log in',
                  style:
                      TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20.h),
                SocialLoginButton(
                  buttonText: 'Continue with Google',
                  imagePath: 'assets/images/google_branding_logo.png',
                  onPressed: () async {
                    await _login(AuthProvider.google, context);
                  },
                ),
                SizedBox(height: 10.h),
                SocialLoginButton(
                  buttonText: 'Continue with Facebook',
                  imagePath: 'assets/images/facebook_branding_logo.png',
                  onPressed: () async {
                    await _login(AuthProvider.facebook, context);
                  },
                ),
                SizedBox(height: 20.h),
                Text.rich(
                  TextSpan(
                    text: 'By continuing, you agree to NutriAI\'s ',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
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
          ),
        );
      },
    );
  }
}
