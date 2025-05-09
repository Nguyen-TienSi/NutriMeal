import 'package:nutriai_app/data/repositories/token_manager.dart';

import 'auth_provider.dart' show AuthProvider;
import 'auth_user.dart' show AuthUser;
import 'facebook_auth_service.dart' show FacebookAuthService;
import 'google_auth_service.dart' show GoogleAuthService;

class AuthManager {
  static final _googleAuthService = GoogleAuthService();
  static final _facebookAuthService = FacebookAuthService();

  static GoogleAuthService getGoogleAuthService() => _googleAuthService;
  static FacebookAuthService getFacebookAuthService() => _facebookAuthService;

  static Future<void> signIn(AuthProvider provider) async {
    await _handleSignIn(provider);
  }

  static Future<void> _handleSignIn(AuthProvider provider) async {
    String? token;
    switch (provider) {
      case AuthProvider.google:
        await _googleAuthService.signIn();
        token = await _googleAuthService.getIdToken();
        break;
      case AuthProvider.facebook:
        await _facebookAuthService.logIn();
        // Wait for token to be available
        int retries = 0;
        while (token == null && retries < 3) {
          token = await _facebookAuthService.getAccessToken();
          if (token == null) {
            await Future.delayed(const Duration(milliseconds: 500));
            retries++;
          }
        }
        if (token == null) {
          throw Exception(
              'Failed to get Facebook access token after multiple attempts');
        }
        break;
    }

    if (token != null) {
      TokenManager.setToken(token, provider);
    } else {
      throw Exception('Failed to get access token');
    }
  }

  static Future<void> signOut() async {
    if (TokenManager.getProvider() == AuthProvider.google) {
      await _googleAuthService.signOut();
    } else if (TokenManager.getProvider() == AuthProvider.facebook) {
      await _facebookAuthService.logOut();
    }
    TokenManager.clear();
  }

  static bool isLoggedIn() {
    return _googleAuthService.isSignedIn || _facebookAuthService.isLoggedIn;
  }

  static Future<AuthUser?> getAuthUser() async {
    if (_googleAuthService.isSignedIn) {
      return AuthUser(
        name: await _googleAuthService.getDisplayName(),
        email: await _googleAuthService.getEmail(),
        photoUrl: await _googleAuthService.getPhotoUrl(),
      );
    } else if (_facebookAuthService.isLoggedIn) {
      return AuthUser(
        name: await _facebookAuthService.getUserName(),
        email: await _facebookAuthService.getUserEmail(),
        photoUrl: await _facebookAuthService.getPictureUrl(),
      );
    }
    return null;
  }
}
