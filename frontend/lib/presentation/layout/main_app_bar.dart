import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nutriai_app/core/app_config.dart';
import 'package:nutriai_app/presentation/views/personal/profile_screen.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart';
import 'package:nutriai_app/service/external-service/notification_service.dart';

class MainAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  State<MainAppBar> createState() => _MainAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight.h);
}

class _MainAppBarState extends State<MainAppBar> {
  final NotificationService _notificationService = NotificationService();
  bool _areNotificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadNotificationStatus();
  }

  Future<void> _loadNotificationStatus() async {
    if (!mounted) return;
    try {
      setState(() => _areNotificationsEnabled = !_areNotificationsEnabled);
    } catch (e) {
      debugPrint("Error loading notification status: $e");
      setState(() => _areNotificationsEnabled = false);
    }
  }

  Future<void> _toggleNotifications() async {
    if (!mounted) return;
    try {
      if (_areNotificationsEnabled) {
        await _notificationService.disableNotifications();
      } else {
        await _notificationService.enableNotifications();
      }
      await _loadNotificationStatus();
    } catch (e) {
      debugPrint("Error toggling notifications: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(appName),
      centerTitle: true,
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
      elevation: 0,
      actionsIconTheme: IconThemeData(color: Colors.white, size: 28.sp),
      actions: [
        AuthManager.isLoggedIn()
            ? IconButton(
                icon: Icon(
                  _areNotificationsEnabled
                      ? Icons.notifications_active
                      : Icons.notifications_off_outlined,
                  size: 28.sp,
                ),
                tooltip: _areNotificationsEnabled
                    ? 'Disable notifications'
                    : 'Enable notifications',
                onPressed: _toggleNotifications,
              )
            : const SizedBox.shrink(),
        IconButton(
          icon: Icon(Icons.account_circle, size: 28.sp),
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
}
