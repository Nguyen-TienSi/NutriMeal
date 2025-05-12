mixin ApiConfig {
  final String _apiVersion = '1';
  final String _httpScheme = 'http';
  final String _apiHost = '192.168.2.9';
  final int _apiPort = 8080;
  final String _apiPath = 'api';
  // final String _apiKey = 'YOUR_API_KEY';

  Uri get apiUri => Uri(
        scheme: _httpScheme,
        host: _apiHost,
        port: _apiPort,
        path: _apiPath,
      );

  Map<String, String> get headers => {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/vnd.company.app-v$_apiVersion+json',
        // 'If-None-Match': '',
        // 'If-Match': '',
        // 'Authorization': 'Bearer $apiKey',
      };

  Uri buildUri(String endPoint, {Map<String, dynamic>? queryParameters}) {
    return apiUri.replace(
      path: '${apiUri.path}$endPoint',
      queryParameters: queryParameters,
    );
  }

  String get apiBaseUrl => '$_httpScheme://$_apiHost:$_apiPort/$_apiPath';
}
