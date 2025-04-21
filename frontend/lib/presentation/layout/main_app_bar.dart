import 'package:flutter/material.dart';
import 'package:nutriai_app/core/app_config.dart';
import 'package:nutriai_app/presentation/views/settings/profile_screen.dart'
    show ProfileScreen;

class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(appName),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
      actionsIconTheme: const IconThemeData(color: Colors.white, size: 28),
      actions: [
        IconButton(
          icon: const Icon(Icons.account_circle, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProfileScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
