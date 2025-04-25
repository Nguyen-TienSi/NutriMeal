import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/views/onboarding/onboarding_screen.dart'
    show OnboardingScreen;
import 'package:nutriai_app/service/external-service/auth_manager.dart';
import 'package:nutriai_app/service/external-service/auth_user.dart'
    show AuthUser;
import 'package:nutriai_app/service/external-service/google_auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<AuthUser?> _authUser = Future.value(null);

  @override
  void initState() {
    super.initState();
    checkSignIn();
  }

  void checkSignIn() async {
    if (await AuthManager.isLoggedIn()) {
      _logUserInfo();
      setState(() {
        _authUser = AuthManager.getAuthUser();
      });
    }
  }

  void _logUserInfo() async {
    final googleAuthService = GoogleAuthService();
    await googleAuthService.signInSilently();
    final accessToken = await googleAuthService.getAccessToken();
    final idToken = await googleAuthService.getIdToken();
    final userInfo = googleAuthService.currentUser;

    debugPrint('AccessToken: $accessToken');
    debugPrint('IdToken: $idToken');
    debugPrint('User Info: $userInfo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SafeArea(
        child: FutureBuilder<AuthUser?>(
          future: _authUser,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final userInfo = snapshot.data;

            if (userInfo == null) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Center(child: Text('User not logged in')),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const OnboardingScreen()),
                        );
                      }
                    },
                    child: const Text('Return to Onboarding Screen'),
                  ),
                ],
              );
            }

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (userInfo.photoUrl != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(userInfo.photoUrl!),
                      radius: 50,
                    ),
                  const SizedBox(height: 16),
                  Text(
                    userInfo.name ?? 'No Name',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    userInfo.email ?? 'No Email',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      await AuthManager.signOut();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const OnboardingScreen()),
                        );
                      }
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
