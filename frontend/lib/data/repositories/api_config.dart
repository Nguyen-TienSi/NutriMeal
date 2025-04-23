mixin ApiConfig {
  String apiVersion = '1';
  String httpScheme = 'http';
  String apiHost = '192.168.2.9';
  int apiPort = 8080;
  String apiPath = 'api';
  String apiKey = 'YOUR_API_KEY';

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
