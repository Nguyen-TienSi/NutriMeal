import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/layout/main_screen_layout.dart'
    show MainScreenLayout;

import 'onboarding_additional_health_goals.dart'
    show OnboardingAdditionalHealthGoals;
import 'onboarding_congratulation.dart' show OnboardingCongratulation;
import 'onboarding_dob.dart' show OnboardingDob;
import 'onboarding_gender.dart' show OnboardingGender;
import 'onboarding_health_goal.dart' show OnboardingHealthGoal;
import 'onboarding_height.dart' show OnboardingHeight;
import 'onboarding_weight.dart' show OnboardingWeight;
import 'onboarding_welcome.dart' show OnboardingWelcome;

int _numPages = onboardingScreens.length;
const Duration _animationDuration = Duration(milliseconds: 300);
const Curve _animationCurve = Curves.easeInOut;
List<Widget> onboardingScreens = [
  OnboardingWelcome(),
  OnboardingHealthGoal(),
  OnboardingAdditionalHealthGoals(),
  OnboardingGender(),
  OnboardingDob(),
  OnboardingWeight(),
  OnboardingHeight(),
  OnboardingCongratulation()
];

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = onboardingScreens;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPreviousPage() {
    if (!_pageController.hasClients) return;
    _pageController.previousPage(
      duration: _animationDuration,
      curve: _animationCurve,
    );
  }

  void _goToNextPage() {
    if (!_pageController.hasClients) return;
    _pageController.nextPage(
      duration: _animationDuration,
      curve: _animationCurve,
    );
  }

  void _skipToEnd() {
    if (!_pageController.hasClients) return;
    _pageController.jumpToPage(_numPages - 1);
  }

  void _finishOnboarding() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreenLayout()));
  }

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = _currentPage == _numPages - 1;

    return Scaffold(
      appBar: AppBar(
        leading: _currentPage > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _goToPreviousPage,
              )
            : null,
        actions: [
          if (!isLastPage)
            TextButton(
              onPressed: _skipToEnd,
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
      ),
      body: SafeArea(
        child: Center(
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _currentPage = value;
              });
            },
            itemCount: controller.length,
            controller: _pageController,
            itemBuilder: (context, index) => controller[index],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        // Use padding for better spacing
        child: ElevatedButton(
          onPressed: isLastPage ? _finishOnboarding : _goToNextPage,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: Text(
            isLastPage ? 'Get Started' : 'Next',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
