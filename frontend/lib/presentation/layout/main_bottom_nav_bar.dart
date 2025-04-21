import 'package:flutter/material.dart';

class MainBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const MainBottomNavBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.green,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: 'Recipes'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Ask AI'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_alt), label: 'Community'),
      ],
    );
  }
}
