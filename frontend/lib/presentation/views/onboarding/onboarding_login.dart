import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/presentation/layout/main_screen_layout.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart';
import 'package:nutriai_app/service/external-service/auth_provider.dart';

class OnboardingLogin extends StatelessWidget {
  final UserCreateData userCreateData;

  const OnboardingLogin({super.key, required this.userCreateData});

  Future<void> _login(AuthProvider provider, BuildContext context) async {
    try {
      await AuthManager.signIn(provider);
      if (!context.mounted) return;

      if (AuthManager.isLoggedIn()) {
        await _createUser(context);
        if (!context.mounted) return;
        _navigateToMainScreen(context);
      } else {
        _showSnackBar(context, 'Login failed. Please try again.');
      }
    } catch (error) {
      _showSnackBar(context, 'An error occurred: $error');
    }
  }

  Future<void> _createUser(BuildContext context) async {
    try {
      await UserService().createUser(userCreateData);
    } catch (error) {
      if (!context.mounted) return;
      _showSnackBar(context, 'An error occurred: $error');
    }
    userCreateData.clear();
  }

  void _navigateToMainScreen(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const MainScreenLayout()),
      (route) => false,
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 48.h),
                _buildLogo(context),
                SizedBox(height: 48.h),
                _buildSocialButton(
                  context,
                  'assets/images/google_branding_logo.png',
                  'Continue with Google',
                  AuthProvider.google,
                ),
                SizedBox(height: 16.h),
                _buildSocialButton(
                    context,
                    'assets/images/facebook_branding_logo.png',
                    'Continue with Facebook',
                    AuthProvider.facebook),
                SizedBox(height: 24.h),
                Text(
                  'By continuing, you agree to our Terms of Service and Privacy Policy',
                  style: TextStyle(fontSize: 12.sp, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  Icon(Icons.restaurant_menu, size: 60.h, color: Colors.white),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            "Welcome to NutriAI",
            style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5),
          ),
          SizedBox(height: 8.h),
          Text(
            "Your personal nutrition companion",
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(BuildContext context, String imageAsset,
      String label, AuthProvider provider) {
    return ElevatedButton(
      onPressed: () async => await _login(provider, context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: EdgeInsets.symmetric(vertical: 16.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
          side: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageAsset, width: 24.w, height: 24.h),
          SizedBox(width: 12.w),
          Text(
            label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
