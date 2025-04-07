import 'package:flutter/material.dart';

import '../views/progress/progress_screen.dart';
import 'main_app_bar.dart';
import '../views/ask-ai/ask_ai_screen.dart';
import '../views/home/home_screen.dart';
import '../views/recipe/recipe_screen.dart';
import '../views/settings/profile_screen.dart';
import 'bottom_nav_bar.dart';

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
    const ProgressScreen(),
    const AskAIScreen(),
    const ProfileScreen(),
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
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
