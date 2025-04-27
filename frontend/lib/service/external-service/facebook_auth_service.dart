import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  AccessToken? _currentAccessToken;
  bool _isLoggingIn = false;
  bool _isLoggedIn = false;

  FacebookAuthService() {
    _checkCurrentUser();
  }

  Future<void> _checkCurrentUser() async {
    _currentAccessToken = await FacebookAuth.instance.accessToken;
    _isLoggedIn = _currentAccessToken != null;
  }

  Future<String?> getAccessToken() =>
      Future.value(_currentAccessToken?.tokenString);

  bool get isLoggingIn => _isLoggingIn;

  bool get isLoggedIn => _isLoggedIn;

  Future<String?> getUserName() => _getUserData().then((data) => data['name']);

  Future<String?> getUserEmail() =>
      _getUserData().then((data) => data['email']);

  Future<String?> getPictureUrl() =>
      _getUserData().then((data) => data['picture']['data']['url'] ?? '');

  Future<void> logIn() async {
    try {
      _setLoggingIn(true);
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      switch (result.status) {
        case LoginStatus.success:
          _currentAccessToken = result.accessToken;
          _setLoggedIn(true);
          break;
        case LoginStatus.cancelled:
        case LoginStatus.failed:
        default:
          _setLoggedIn(false);
          break;
      }
    } catch (error) {
      debugPrint('Facebook Sign-In error: $error');
      _setLoggingIn(false);
      rethrow;
    } finally {
      _setLoggingIn(false);
    }
  }

  Future<void> logOut() async {
    try {
      await FacebookAuth.instance.logOut();
      _setLoggedIn(false);
    } catch (error) {
      debugPrint('Facebook Sign-Out error: $error');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> _getUserData() async {
    return await FacebookAuth.instance.getUserData(
      fields: "name,email,picture.width(200)",
    );
  }

  void _setLoggingIn(bool value) {
    _isLoggingIn = value;
  }

  void _setLoggedIn(bool value) {
    _isLoggedIn = value;
  }
}
