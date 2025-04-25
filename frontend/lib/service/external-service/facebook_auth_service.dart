import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookAuthService {
  Future<LoginResult> login() async {
    return await FacebookAuth.instance.login();
  }

  Future<void> logOut() async {
    await FacebookAuth.instance.logOut();
  }

  Future<AccessToken?> getAccessToken() async {
    return await FacebookAuth.instance.accessToken;
  }

  Future<bool> isLoggedIn() async {
    final token = await FacebookAuth.instance.accessToken;
    return token != null;
  }

  Future<Map<String, dynamic>> getUserData() async {
    final userData = await FacebookAuth.instance.getUserData(
      fields: "name,email,picture.width(200)",
    );
    return userData;
  }
}
