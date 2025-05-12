import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutriai_app/presentation/layout/main_app_bar.dart';
import 'package:nutriai_app/presentation/layout/main_bottom_nav_bar.dart';
import 'package:nutriai_app/presentation/views/ask-ai/ask_ai_screen.dart';
import 'package:nutriai_app/presentation/views/community/social_post_screen.dart';
import 'package:nutriai_app/presentation/views/home/home_screen.dart';
import 'package:nutriai_app/presentation/views/health-progress-tracking/health_progress_tracking_screen.dart';
import 'package:nutriai_app/presentation/views/recipe/recipe_screen.dart';

class MainScreenLayout extends StatefulWidget {
  const MainScreenLayout({super.key});

  @override
  State<MainScreenLayout> createState() => _MainScreenLayoutState();
}

class _MainScreenLayoutState extends State<MainScreenLayout> {
  int _selectedIndex = 0;
  final List<GlobalKey<RefreshIndicatorState>> _refreshKeys = List.generate(
    5,
    (index) => GlobalKey<RefreshIndicatorState>(),
  );
  late final List<Widget> _screens;

  Future<void> _handleBackNavigation() async {
    // If we're on the home screen, show a confirmation dialog
    if (_selectedIndex == 0) {
      if (!mounted) return;
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (shouldPop ?? false) {
        SystemNavigator.pop();
      }
    } else {
      setState(() => _selectedIndex = 0);
    }
  }

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeScreen(refreshKey: _refreshKeys[0]),
      RecipeScreen(refreshKey: _refreshKeys[1]),
      HealthProgressTrackingScreen(refreshKey: _refreshKeys[2]),
      AskAIScreen(),
      SocialPostScreen(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            _handleBackNavigation();
          }
        },
        child: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
      ),
      bottomNavigationBar: MainBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
