import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/layout/main_app_bar.dart'
    show MainAppBar;
import 'package:nutriai_app/presentation/layout/main_bottom_nav_bar.dart'
    show MainBottomNavBar;
import 'package:nutriai_app/presentation/views/ask-ai/ask_ai_screen.dart'
    show AskAIScreen;
import 'package:nutriai_app/presentation/views/community/social_post_screen.dart'
    show SocialPostScreen;
import 'package:nutriai_app/presentation/views/home/home_screen.dart'
    show HomeScreen;
import 'package:nutriai_app/presentation/views/health-progress-tracking/health_progress_tracking_screen.dart'
    show HealthProgressTrackingScreen;
import 'package:nutriai_app/presentation/views/recipe/recipe_screen.dart'
    show RecipeScreen;

class MainScreenLayout extends StatefulWidget {
  const MainScreenLayout({super.key});

  @override
  State<MainScreenLayout> createState() => _State();
}

class _State extends State<MainScreenLayout> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const RecipeScreen(),
    const HealthProgressTrackingScreen(),
    const AskAIScreen(),
    const SocialPostScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: SafeArea(
          child: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      )),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
