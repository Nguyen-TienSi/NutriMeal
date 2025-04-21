abstract class ApiProvider {
  Future<T> get<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<T> post<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<T> put<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<T> patch<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  });

  Future<T> delete<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  });

  Future<dynamic> head({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  });

  Future<Map<String, dynamic>> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  });

  Future<bool> isServerAvailable({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  });

  Future<bool> isInternetAvailable();

  void handleError(Exception e);
}
