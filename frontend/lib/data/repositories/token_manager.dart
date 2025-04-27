import 'package:nutriai_app/service/external-service/auth_provider.dart'
    show AuthProvider;

class TokenManager {
  static final TokenManager _instance = TokenManager._internal();
  factory TokenManager() => _instance;
  TokenManager._internal();

  static AuthProvider? _provider;
  static String? _token;

  static void setToken(String token, AuthProvider provider) {
    _token = token;
    _provider = provider;
  }

  static String? getValidToken() => _token;

  static void clear() {
    _token = null;
    _provider = null;
  }
}
