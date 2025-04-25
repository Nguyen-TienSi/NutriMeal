import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'auth_provider.dart' show AuthProvider;
import 'auth_user.dart' show AuthUser;
import 'facebook_auth_service.dart' show FacebookAuthService;
import 'google_auth_service.dart' show GoogleAuthService;

class AuthManager {
  static final _googleAuthService = GoogleAuthService();
  static final _facebookAuthService = FacebookAuthService();

  static Future<AuthUser?> signIn(AuthProvider provider) async {
    final authUser = await _handleSignIn(provider);
    return authUser;
  }

  static Future<AuthUser?> _handleSignIn(AuthProvider provider) async {
    switch (provider) {
      case AuthProvider.facebook:
        return await _signInWithFacebook();
      case AuthProvider.google:
        return await _signInWithGoogle();
    }
  }

  static Future<AuthUser?> _signInWithFacebook() async {
    final result = await _facebookAuthService.login();
    if (result.status == LoginStatus.success) {
      final userData = await _facebookAuthService.getUserData();
      return AuthUser(
        name: userData['name'],
        email: userData['email'],
        photoUrl: userData['picture']['data']['url'],
      );
    }
    return null;
  }

  static Future<AuthUser?> _signInWithGoogle() async {
    await _googleAuthService.signIn();
    if (_googleAuthService.currentUser != null) {
      return AuthUser(
        name: await _googleAuthService.getDisplayName(),
        email: await _googleAuthService.getEmail(),
        photoUrl: await _googleAuthService.getPhotoUrl(),
      );
    }
    return null;
  }

  static Future<String?> getAccessToken() async {
    return await _facebookAuthService.getAccessToken() as String? ??
        await _googleAuthService.getAccessToken();
  }

  static Future<void> signOut() async {
    await _googleAuthService.signOut();
    await _facebookAuthService.logOut();
  }

  static Future<bool> isLoggedIn() async {
    return _googleAuthService.isSignedIn ||
        await _facebookAuthService.isLoggedIn();
  }

  static Future<AuthUser?> getAuthUser() async {
    if (_googleAuthService.isSignedIn) {
      return AuthUser(
        name: await _googleAuthService.getDisplayName(),
        email: await _googleAuthService.getEmail(),
        photoUrl: await _googleAuthService.getPhotoUrl(),
      );
    } else if (await _facebookAuthService.isLoggedIn()) {
      final userData = await _facebookAuthService.getUserData();
      return AuthUser(
        name: userData['name'],
        email: userData['email'],
        photoUrl: userData['picture']['data']['url'],
      );
    }
    return null;
  }
}
