import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:nutriai_app/exception/server_exception.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'api_config.dart' show ApiConfig;
import 'http_provider.dart' show HttpProvider;
import 'token_manager.dart' show TokenManager;

class DioApiProvider extends HttpProvider with ApiConfig {
  final Dio dio = Dio();

  DioApiProvider() {
    dio.options = BaseOptions(
      baseUrl: apiBaseUrl,
      connectTimeout: Duration(milliseconds: 5000),
      receiveTimeout: Duration(milliseconds: 3000),
      sendTimeout: Duration(milliseconds: 3000),
      headers: headers,
      responseType: ResponseType.json,
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final uri =
            buildUri(options.path, queryParameters: options.queryParameters);
        final prefs = await SharedPreferences.getInstance();
        final storedEtag = prefs.getString('etag_$uri');

        if (storedEtag != null) {
          options.headers['If-None-Match'] = storedEtag;
          options.headers['If-Match'] = storedEtag;
        }

        final token = TokenManager.getValidToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        final uri = buildUri(response.requestOptions.path,
            queryParameters: response.requestOptions.queryParameters);
        final etag = response.headers.value('etag');
        if (etag != null) {
          SharedPreferences.getInstance().then((prefs) {
            prefs.setString('etag_$uri', etag);
          });
        }
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        if (error.response?.statusCode == 401) {
          try {
            // Có thể thử lấy lại token mới từ TokenManager
            TokenManager.clear(); // Xóa token cũ
            final newToken = TokenManager.getValidToken();

            if (newToken != null && newToken.isNotEmpty) {
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
        } else if (error.response?.statusCode == 500) {
          debugPrint('🔴 Server error: ${error.response?.data}');
          throw ServerException(
            message: '⚠️ Internal Server Error: ${error.response?.data}',
            statusCode: error.response?.statusCode,
          );
        }

        return handler.next(error);
      },
    ));
  }

  @override
  Future<dynamic> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    var data,
  }) async {
    Response response = switch (method.toUpperCase()) {
      'GET' => await dio.get(endPoint, queryParameters: queryParameters),
      'POST' =>
        await dio.post(endPoint, queryParameters: queryParameters, data: data),
      'PUT' =>
        await dio.put(endPoint, queryParameters: queryParameters, data: data),
      'PATCH' =>
        await dio.patch(endPoint, queryParameters: queryParameters, data: data),
      'DELETE' => await dio.delete(endPoint, queryParameters: queryParameters),
      'HEAD' => await dio.head(endPoint, queryParameters: queryParameters),
      _ => throw UnsupportedError('HTTP method $method is not supported'),
    };

    if (!await isServerAvailable(response)) {
      debugPrint('🔴 Server respond error!');
      throw ServerException(
          message: '⚠️ Server respond error!', statusCode: response.statusCode);
    }

    return _processResponse(response);
  }

  @override
  Future head({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) {
    try {
      return sendRequest(
        method: 'HEAD',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );
    } catch (e, stackTrace) {
      if (e is Exception) {
        handleError(e);
      } else {
        debugPrint('Unknown error: $e\n$stackTrace');
      }
      rethrow;
    }
  }

  @override
  Future<T> get<T>(
      {required String endPoint,
      Map<String, dynamic>? queryParameters,
      T Function(dynamic)? fromJson}) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_${uri.toString()}';
    const cacheDuration = Duration(minutes: 0);

    try {
      if (!await isInternetAvailable()) {
        throw SocketException("⚠️ No Internet ");
      }

      await head(
          endPoint: queryParameters != null ? endPoint : 'health',
          queryParameters: queryParameters);

      final data = await sendRequest(
        method: 'GET',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );

      await _cacheData(prefs, cacheKey, data);
      return fromJson != null ? fromJson(data) : data as T;
    } catch (e, stackTrace) {
      if (e is Exception) {
        handleError(e);
      } else {
        debugPrint('Unknown error: $e\n$stackTrace');
      }
      final cachedData = await _getCachedData(prefs, cacheKey, cacheDuration);
      if (cachedData != null) {
        return fromJson?.call(cachedData) ?? cachedData as T;
      } else {
        debugPrint('🔴 No cached data available for $cacheKey');
      }
      rethrow;
    }
  }

  @override
  Future<T> patch<T>(
      {required String endPoint,
      var data,
      var files,
      T Function(dynamic)? fromJson}) {
    // TODO: implement patch
    throw UnimplementedError();
  }

  @override
  Future<T> post<T>(
      {required String endPoint,
      var data,
      var files,
      T Function(dynamic)? fromJson}) {
    // TODO: implement post
    throw UnimplementedError();
  }

  @override
  Future<T> put<T>(
      {required String endPoint,
      var data,
      var files,
      T Function(dynamic)? fromJson}) {
    // TODO: implement put
    throw UnimplementedError();
  }

  @override
  Future<T> delete<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  dynamic _processResponse(Response response) {
    if ([204, 304, 404].contains(response.statusCode) &&
        response.data.isEmpty) {
      return null;
    }
    try {
      if (response.data is String) return jsonDecode(response.data);
      return response.data;
    } catch (e) {
      throw ServerException(
          message: '⚠️ Invalid JSON format: $e',
          statusCode: response.statusCode);
    }
  }

  Future<dynamic> _getCachedData(
      SharedPreferences prefs, String cacheKey, Duration cacheDuration) async {
    final cached = prefs.getString(cacheKey);
    if (cached != null) {
      final decoded = jsonDecode(cached);
      final timestamp =
          DateTime.fromMillisecondsSinceEpoch(decoded['timestamp']);
      if (DateTime.now().difference(timestamp) < cacheDuration) {
        debugPrint('🟡 [Offline] Returning valid cache for $cacheKey');
        return decoded['data'];
      }
    }
    debugPrint('🔴 [Offline] No valid cache for $cacheKey');
    return null;
  }

  Future<void> _cacheData(
      SharedPreferences prefs, String cacheKey, dynamic data) async {
    await prefs.setString(
        cacheKey,
        jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': data,
        }));
    debugPrint('🟢 [Online] Fetched & cached $cacheKey');
  }
}
