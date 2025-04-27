abstract class ApiProvider {
  Future<dynamic> head({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  });

  Future<T> get<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    T Function(dynamic)? fromJson,
  });

  Future<T> post<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic)? fromJson,
  });

  Future<T> put<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic)? fromJson,
  });

  Future<T> patch<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic)? fromJson,
  });

  Future<T> delete<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    var data,
  });

  Future<bool> isServerAvailable(dynamic response);

  Future<bool> isInternetAvailable();

  void handleError(Exception e);
}
