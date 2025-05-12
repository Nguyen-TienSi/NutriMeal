import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/data/models/user_create_data.dart';
import 'package:nutriai_app/presentation/layout/main_screen_layout.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart';

import 'onboarding_activity_level.dart';
import 'onboarding_additional_health_goals.dart';
import 'onboarding_congratulation.dart';
import 'onboarding_dob.dart';
import 'onboarding_gender.dart';
import 'onboarding_health_goal.dart';
import 'onboarding_height.dart';
import 'onboarding_login.dart';
import 'onboarding_target_weight.dart';
import 'onboarding_weight.dart';
import 'onboarding_welcome.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final userCreateData = UserCreateData();
  final PageController _pageController = PageController();
  final Duration _animationDuration = const Duration(milliseconds: 300);
  final Curve _animationCurve = Curves.easeInOut;

  late final List<Widget> _onboardingScreens;
  late final int _numPages;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _initializeScreens();
    _numPages = _onboardingScreens.length;

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    // Check if user is already logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AuthManager.isLoggedIn()) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const MainScreenLayout()),
          (route) => false,
        );
      }
    });
  }

  void _initializeScreens() {
    _onboardingScreens = [
      const OnboardingWelcome(),
      OnboardingHealthGoal(userCreateData: userCreateData),
      const OnboardingAdditionalHealthGoals(),
      OnboardingGender(userCreateData: userCreateData),
      OnboardingDob(userCreateData: userCreateData),
      OnboardingActivityLevel(userCreateData: userCreateData),
      OnboardingWeight(userCreateData: userCreateData),
      OnboardingTargetWeight(userCreateData: userCreateData),
      OnboardingHeight(userCreateData: userCreateData),
      const OnboardingCongratulation(),
      OnboardingLogin(userCreateData: userCreateData),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _navigateToPage(int page) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      page,
      duration: _animationDuration,
      curve: _animationCurve,
    );
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainScreenLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _numPages - 1;

    return Scaffold(
      appBar: _buildAppBar(isLastPage),
      body: SafeArea(
        child: PageView.builder(
          controller: _pageController,
          itemCount: _onboardingScreens.length,
          itemBuilder: (context, index) => _onboardingScreens[index],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(isLastPage),
    );
  }

  AppBar _buildAppBar(bool isLastPage) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: _currentPage > 0
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => _navigateToPage(_currentPage - 1),
            )
          : null,
      actions: [
        if (!isLastPage)
          TextButton(
            onPressed: () => _navigateToPage(_numPages - 1),
            child: const Text('Skip', style: TextStyle(color: Colors.green)),
          )
        else
          IconButton(
            icon: const Icon(Icons.check),
            tooltip: 'Finish Onboarding',
            onPressed: _finishOnboarding,
          ),
      ],
      title: Text('Step ${_currentPage + 1} of $_numPages'),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  Widget _buildBottomNavigationBar(bool isLastPage) {
    return BottomAppBar(
      child: ElevatedButton(
        onPressed: isLastPage
            ? _finishOnboarding
            : () => _navigateToPage(_currentPage + 1),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: Text(
          isLastPage ? 'Get Started' : 'Next',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
