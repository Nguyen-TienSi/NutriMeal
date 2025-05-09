import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nutriai_app/exception/server_exception.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

import 'api_config.dart';
import 'http_provider.dart';
import 'token_manager.dart' show TokenManager;

class HttpApiProvider extends HttpProvider with ApiConfig {
  @override
  Future<dynamic> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    var data,
  }) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);
    final prefs = await SharedPreferences.getInstance();
    final storedEtag = prefs.getString('etag_$uri');
    final token = TokenManager.getValidToken();
    final requestHeaders = Map<String, String>.from(headers);

    if (storedEtag != null) {
      if (method.toUpperCase() == 'GET') {
        // requestHeaders['If-None-Match'] = storedEtag;
      } else if (method.toUpperCase() == 'PATCH') {
        requestHeaders['If-Match'] = storedEtag;
      }
    }

    if (method.toUpperCase() == 'PATCH') {
      requestHeaders['Content-Type'] = 'application/json-patch+json';
    }
    if (token != null) requestHeaders['Authorization'] = 'Bearer $token';
    debugPrint('🔑 Send Token: "$token"');

    http.Response response = switch (method.toUpperCase()) {
      'HEAD' => await http.head(uri, headers: requestHeaders),
      'GET' => await http.get(uri, headers: requestHeaders),
      'POST' =>
        await http.post(uri, headers: requestHeaders, body: jsonEncode(data)),
      'PUT' =>
        await http.put(uri, headers: requestHeaders, body: jsonEncode(data)),
      'PATCH' =>
        await http.patch(uri, headers: requestHeaders, body: jsonEncode(data)),
      'DELETE' => await http.delete(uri, headers: requestHeaders),
      _ => throw UnimplementedError('HTTP method $method not supported'),
    };

    if (!await isServerAvailable(response)) {
      debugPrint('🔴 Server respond error!');
      throw ServerException(
          message: '⚠️ Server respond error!', statusCode: response.statusCode);
    }

    // Store ETag from response, checking both cases
    final etag = response.headers['etag'] ?? response.headers['ETag'];
    if (etag != null) await prefs.setString('etag_$uri', etag);

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
    // final prefs = await SharedPreferences.getInstance();
    // final cacheKey = 'cache_${uri.toString()}';
    // const cacheDuration = Duration(minutes: 0);

    try {
      if (!await isInternetAvailable()) {
        throw SocketException("⚠️ No Internet ");
      }

      await head(
          endPoint: queryParameters != null ? endPoint : '/health',
          queryParameters: queryParameters);

      final data = await sendRequest(
        method: 'GET',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );

      // await _cacheData(prefs, cacheKey, data);
      return fromJson != null ? fromJson(data) : data as T;
    } catch (e, stackTrace) {
      if (e is Exception) {
        handleError(e);
      } else {
        debugPrint('Unknown error: $e\n$stackTrace');
      }
      // final cachedData = await _getCachedData(prefs, cacheKey, cacheDuration);
      // if (cachedData != null) {
      //   return fromJson?.call(cachedData) ?? cachedData as T;
      // } else {
      //   debugPrint('🔴 No cached data available for $cacheKey');
      // }
      rethrow;
    }
  }

  @override
  Future<T> patch<T>(
      {required String endPoint,
      var data,
      var files,
      T Function(dynamic)? fromJson}) async {
    try {
      return await sendRequest(
        method: 'PATCH',
        endPoint: endPoint,
        data: data,
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
  Future<T> post<T>(
      {required String endPoint,
      var data,
      var files,
      T Function(dynamic)? fromJson}) async {
    try {
      return await sendRequest(
        method: 'POST',
        endPoint: endPoint,
        data: data,
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
  }) async {
    try {
      return await sendRequest(
        method: 'DELETE',
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

  dynamic _processResponse(http.Response response) {
    if ([204, 304, 404].contains(response.statusCode) ||
        response.body.isEmpty) {
      return null;
    }
    try {
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint('Response body: ${response.body}');
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
    debugPrint('🔴 [Offline] No valid cache available for $cacheKey');
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
