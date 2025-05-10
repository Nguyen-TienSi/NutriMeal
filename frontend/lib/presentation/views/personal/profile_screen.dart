import 'package:flutter/material.dart';
import 'package:nutriai_app/data/models/user_detail_data.dart';
import 'package:nutriai_app/data/repositories/token_manager.dart';
import 'package:nutriai_app/presentation/views/onboarding/onboarding_screen.dart';
import 'package:nutriai_app/presentation/views/personal/personal_detail_screen.dart';
import 'package:nutriai_app/service/api-service/user_service.dart';
import 'package:nutriai_app/service/external-service/auth_manager.dart';
import 'package:nutriai_app/service/external-service/auth_user.dart';
import 'package:nutriai_app/presentation/views/personal/personal_summary_card.dart';
import 'package:nutriai_app/presentation/views/personal/personal_navigation_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<AuthUser?> authUser = Future.value(null);
  UserDetailData? userDetailData;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    checkSignIn();
    fetchData();
  }

  void checkSignIn() async {
    if (AuthManager.isLoggedIn()) {
      _logInfo();
      final authUser = await AuthManager.getAuthUser();
      setState(() {
        this.authUser = Future.value(authUser);
      });
    }
  }

  Future<void> _logInfo() async {
    final userInfo = AuthManager.getGoogleAuthService().currentUser;
    final idToken = TokenManager.getValidToken();
    debugPrint('👤 User Info: $userInfo');
    debugPrint('🔑 Token: "$idToken"');
  }

  Future<void> fetchData() async {
    try {
      setState(() => isLoading = true);
      final userDetailData = await UserService().getUserDetailData();
      setState(() {
        this.userDetailData = userDetailData;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error fetching user detail data: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: FutureBuilder<AuthUser?>(
          future: authUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userInfo = snapshot.data;

            if (userInfo == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => const OnboardingScreen()),
                      );
                    }
                  },
                  child: const Text('Create Account'),
                ),
              );
            }

            return isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      if (userDetailData != null)
                        PersonalSummaryCard(userDetailData: userDetailData!),
                      const SizedBox(height: 16),
                      PersonalNavigationCard(
                        icon: Icons.person,
                        title: 'Personal details',
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PersonalDetailScreen(
                                  userDetailData: userDetailData),
                            ),
                          );
                        },
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 24),
                        child: SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFF8D7DA),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              foregroundColor: const Color(0xFFC0392B),
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.1,
                                fontSize: 16,
                              ),
                            ),
                            onPressed: () async {
                              await AuthManager.signOut();
                              if (context.mounted) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (_) => const OnboardingScreen()),
                                );
                              }
                            },
                            child: const Text('LOG OUT'),
                          ),
                        ),
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }
}
