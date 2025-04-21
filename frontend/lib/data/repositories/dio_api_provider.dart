import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'api_config.dart' show ApiConfig;
import 'http_provider.dart' show HttpProvider;

class DioApiProvider extends HttpProvider with ApiConfig {
  final Dio dio = Dio();

  DioApiProvider() {
    dio.options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      sendTimeout: Duration(milliseconds: 3000),
      headers: headers,
      contentType: 'application/json',
      responseType: ResponseType.json,
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getAccessToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          // Thử refresh token
          try {
            final newToken = await refreshAccessToken();

            if (newToken != null && newToken.isNotEmpty) {
              // Gán token mới vào request cũ và retry
              final options = error.requestOptions;
              options.headers['Authorization'] = 'Bearer $newToken';

              final retryResponse = await dio.fetch(options);
              return handler.resolve(retryResponse);
            } else {
              return handler.reject(error);
            }
          } catch (e) {
            return handler.reject(error);
          }
        }

        return handler.next(error);
      },
    ));
  }

  @override
  Future<T> get<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);
    final cacheKey = 'cache_${uri.toString()}';
    final prefs = await SharedPreferences.getInstance();
    const cacheDuration = Duration(minutes: 0);

    try {
      if (!await isInternetAvailable()) {
        final cached = prefs.getString(cacheKey);
        if (cached != null) {
          final decoded = jsonDecode(cached);
          final timestamp =
              DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);
          final now = DateTime.now();
          if (now.difference(timestamp) < cacheDuration) {
            debugPrint('🟡 [Offline] Returning valid cache for $cacheKey');
            return decoded['data'];
          }
        }
        throw SocketException("No Internet and no valid cache available");
      }

      if (!await isServerAvailable()) {
        debugPrint('🔴 Server is not available!');
        throw Exception("Server is down");
      }

      final data = await sendRequest(
        method: 'GET',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );

      final cacheObject = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': data,
      };

      await prefs.setString(cacheKey, jsonEncode(cacheObject));
      debugPrint('🟢 [Online] Fetched & cached $cacheKey');

      return fromJson != null ? fromJson(data) : data as T;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<T> post<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await sendRequest(
        method: 'POST', endPoint: endPoint, data: data, files: files);
    return fromJson != null ? fromJson(response) : response as T;
  }

  @override
  Future<T> put<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await sendRequest(
        method: 'PUT', endPoint: endPoint, data: data, files: files);
    return fromJson != null ? fromJson(response) : response as T;
  }

  @override
  Future<T> patch<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    final response = await sendRequest(
        method: 'PATCH', endPoint: endPoint, data: data, files: files);
    return fromJson != null ? fromJson(response) : response as T;
  }

  @override
  Future<T> delete<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await sendRequest(
        method: 'DELETE', endPoint: endPoint, queryParameters: queryParameters);
    return response as T;
  }

  Map<String, dynamic> _processResponse(Response response) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data;
    } else {
      throw HttpException('Invalid JSON: ${response.data}');
    }
  }

  @override
  Future<Response> head(
      {required String endPoint, Map<String, dynamic>? queryParameters}) async {
    try {
      if (!await isInternetAvailable()) {
        throw SocketException("No Internet");
      }
      if (!await isServerAvailable()) {
        throw SocketException("Server is down");
      }
      if (queryParameters != null) {
        return await dio.head(endPoint, queryParameters: queryParameters);
      }
      return await dio.head(endPoint);
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
  }) async {
    try {
      if (!await isInternetAvailable()) {
        throw const SocketException("No Internet");
      }

      if (!await isServerAvailable()) {
        throw const SocketException("Server is down");
      }

      final requestData = files != null && files.isNotEmpty
          ? await _buildFormData(data, files)
          : data;

      Response response = switch (method.toUpperCase()) {
        'GET' => await dio.get(endPoint, queryParameters: queryParameters),
        'POST' => await dio.post(endPoint, data: requestData),
        'PUT' => await dio.put(endPoint, data: requestData),
        'PATCH' => await dio.patch(endPoint, data: requestData),
        'DELETE' =>
          await dio.delete(endPoint, queryParameters: queryParameters),
        'HEAD' => await dio.head(endPoint),
        _ => throw UnsupportedError('HTTP method $method is not supported'),
      };

      return _processResponse(response);
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  Future<FormData> _buildFormData(
      Map<String, dynamic>? data, Map<String, dynamic> files) async {
    final formData = FormData.fromMap(data ?? {});
    for (final entry in files.entries) {
      formData.files.add(MapEntry(
        entry.key,
        await MultipartFile.fromFile(entry.value),
      ));
    }
    return formData;
  }

  Future<String?> getAccessToken() async {
    // Ví dụ đọc từ SharedPreferences hoặc secure storage
    return 'your_access_token';
  }

  Future<String?> refreshAccessToken() async {
    // Gọi API refresh token
    final refreshToken = 'your_refresh_token';
    final response = await dio.post('/auth/refresh', data: {
      'refresh_token': refreshToken,
    });

    if (response.statusCode == 200) {
      final newToken = response.data['access_token'];
      // Lưu lại token mới
      // await saveAccessToken(newToken);
      return newToken;
    }

    return null;
  }
}
