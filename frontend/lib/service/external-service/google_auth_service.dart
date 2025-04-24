import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['openid', 'email', 'profile'],
    serverClientId:
        '760175289893-3qi56cjjrp25k325546o4taaj26keinf.apps.googleusercontent.com',
  );

  GoogleSignInAccount? _currentUser;
  bool _isSigningIn = false;
  bool _isSignedIn = false;

  GoogleAuthService() {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      _setSigningIn(false);
      _setSignedIn(account != null);
      debugPrint('Current user changed: ${account?.email}');
    });
    _googleSignIn.signInSilently();
  }

  bool get isSigningIn => _isSigningIn;
  bool get isSignedIn => _isSignedIn;
  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> signInWithGoogle() async {
    _setSigningIn(true);
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _currentUser = account;
        _setSignedIn(true);
        debugPrint('Google Sign-In successful: ${account.email}');
      } else {
        debugPrint('Google Sign-In canceled by user.');
        _setSignedIn(false);
      }
    } catch (error) {
      debugPrint('Google Sign-In error: $error');
      if (error is PlatformException) {
        debugPrint('Google Sign-In PlatformException: ${error.message}');
      }
      _setSigningIn(false);
      rethrow;
    }
  }

  Future<void> signOutGoogle() async {
    try {
      await _googleSignIn.signOut();
      _setSignedIn(false);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signInSilently() async {
    _setSigningIn(true);
    try {
      await _googleSignIn.signInSilently();
    } catch (error) {
      _setSigningIn(false);
      rethrow;
    }
  }

  Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      _setSignedIn(false);
    } catch (error) {
      rethrow;
    }
  }

  Future<String?> getAccessToken() =>
      _getAuthenticationToken((auth) => Future.value(auth.accessToken));

  Future<String?> getIdToken() =>
      _getAuthenticationToken((auth) => Future.value(auth.idToken));

  Future<String?> getEmail() async => _currentUser?.email;

  Future<String?> getDisplayName() async => _currentUser?.displayName;

  Future<String?> getPhotoUrl() async => _currentUser?.photoUrl;

  Future<String?> getId() async => _currentUser?.id;

  Future<String?> getServerAuthCode() async => _currentUser?.serverAuthCode;

  Future<String?> _getAuthenticationToken(
      Future<String?> Function(GoogleSignInAuthentication)
          tokenExtractor) async {
    try {
      final auth = await _currentUser?.authentication;
      return auth != null ? await tokenExtractor(auth) : null;
    } catch (error) {
      rethrow;
    }
  }

  void _setSigningIn(bool value) {
    _isSigningIn = value;
  }

  void _setSignedIn(bool value) {
    _isSignedIn = value;
  }
}
