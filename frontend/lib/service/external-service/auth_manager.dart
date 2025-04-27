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
        token = await _facebookAuthService.getAccessToken();
        break;
    }

    if (token != null) TokenManager.setToken(token, provider);
  }

  static Future<void> signOut() async {
    await _googleAuthService.signOut();
    await _facebookAuthService.logOut();
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
