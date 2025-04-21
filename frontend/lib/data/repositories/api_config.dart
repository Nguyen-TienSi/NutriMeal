mixin ApiConfig {
  static const String apiVersion = '1';
  static const String httpScheme = 'http';
  static const String apiHost = '10.0.2.2';
  static const int apiPort = 8080;
  static const String apiPath = 'api';
  static const String apiKey = 'YOUR_API_KEY';

  Uri get apiUri => Uri(
        scheme: httpScheme,
        host: apiHost,
        port: apiPort,
        path: apiPath,
      );

  Map<String, String> get headers => {
        'Content-Type': 'application/json;charset=UTF-8',
        'Accept': 'application/vnd.company.app-v1+json',
        'If-None-Match': '',
        'If-Match': '',
        // 'Authorization': 'Bearer $apiKey',
      };

  Uri buildUri(String endPoint, {Map<String, dynamic>? queryParameters}) {
    return apiUri.replace(
      path: '${apiUri.path}/$endPoint',
      queryParameters: queryParameters,
    );
  }

  String get apiBaseUrl => '$httpScheme://$apiHost:$apiPort/$apiPath';
}
