import 'package:flutter/material.dart';
import 'package:nutriai_app/presentation/views/onboarding/onboarding_screen.dart'
    show OnboardingScreen;
import 'package:nutriai_app/service/external-service/google_auth_service.dart'
    show GoogleAuthService;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _State();
}

class _State extends State<ProfileScreen> {
  final GoogleAuthService googleSignInService = GoogleAuthService();

  @override
  void initState() {
    super.initState();
    _checkSignIn();
  }

  void _checkSignIn() async {
    await googleSignInService.signInSilently();
    if (googleSignInService.isSignedIn) {
      _logUserInfo();
      setState(() {});
    }
  }

  void _logUserInfo() async {
    final accessToken = await googleSignInService.getAccessToken();
    final idToken = await googleSignInService.getIdToken();
    final userInfo = googleSignInService.currentUser;

    debugPrint('AccessToken: $accessToken');
    debugPrint('IdToken: $idToken');
    debugPrint('User Info: $userInfo');
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = googleSignInService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: userInfo == null
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (userInfo.photoUrl != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(userInfo.photoUrl!),
                        radius: 50,
                      ),
                    const SizedBox(height: 16),
                    Text(
                      userInfo.displayName ?? 'No Name',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userInfo.email,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await googleSignInService.signOutGoogle();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ));
                        });
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
