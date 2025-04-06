import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/views/progress/progress_screen.dart';
import 'package:nutriai_app/presentation/layout/app_header.dart';

import '../views/ask-ai/ask_ai_screen.dart';
import '../views/home/home_screen.dart';
import '../views/recipe/recipe_screen.dart';
import '../views/settings/profile_screen.dart';
import 'bottom_nav_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _State();
}

class _State extends State<MainScreen> {
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
      appBar: AppHeader(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
