import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'api_config.dart';
import 'http_provider.dart';

class HttpApiProvider extends HttpProvider with ApiConfig {
  Timer? _debounce;

  @override
  Future<Map<String, dynamic>> sendRequest({
    required String method,
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
  }) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);

    http.Response response = switch (method.toUpperCase()) {
      'GET' => await http.get(uri, headers: headers),
      'POST' => await http.post(uri, headers: headers, body: jsonEncode(data)),
      'PUT' => await http.put(uri, headers: headers, body: jsonEncode(data)),
      'PATCH' =>
        await http.patch(uri, headers: headers, body: jsonEncode(data)),
      'DELETE' => await http.delete(uri, headers: headers),
      _ => throw UnimplementedError('HTTP method $method not supported'),
    };

    return _processResponse(response);
  }

  @override
  Future<T> get<T>({
    required String endPoint,
    T Function(Map<String, dynamic>)? fromJson,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'cache_${uri.toString()}';
    const cacheDuration = Duration(minutes: 0);

    try {
      if (!await isInternetAvailable()) {
        final cachedData = await _getCachedData(prefs, cacheKey, cacheDuration);
        return fromJson!(cachedData) ?? cachedData as T;
      }

      final etagResponse =
          await head(endPoint: endPoint, queryParameters: queryParameters);

      if (etagResponse.statusCode == 304) {
        final cachedData = await _getCachedData(prefs, cacheKey, cacheDuration);
        debugPrint('🟡 [Offline] Returning valid cache for $cacheKey');
        return fromJson!(cachedData) ?? cachedData as T;
      }

      final data = await sendRequest(
        method: 'GET',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );

      await _cacheData(prefs, cacheKey, data);

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
    try {
      if (!await isInternetAvailable()) throw SocketException("No Internet");
      if (!await isServerAvailable()) throw Exception("Server is down");

      if (files != null && files.isNotEmpty) {
        final uri = buildUri(endPoint);
        final request = http.MultipartRequest('POST', uri);
        request.fields
            .addAll(data?.map((k, v) => MapEntry(k, v.toString())) ?? {});
        for (var entry in files.entries) {
          request.files
              .add(await http.MultipartFile.fromPath(entry.key, entry.value));
        }
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        final processedResponse = _processResponse(response);
        return fromJson != null
            ? fromJson(processedResponse)
            : processedResponse as T;
      }

      final responseData =
          await sendRequest(method: 'POST', endPoint: endPoint, data: data);
      return fromJson != null ? fromJson(responseData) : responseData as T;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<T> put<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      if (!await isInternetAvailable()) throw SocketException("No Internet");
      if (!await isServerAvailable(
        endPoint: '$endPoint/search',
        queryParameters: {'id': data?['id']},
      )) {
        throw Exception("Server is down");
      }
      final response =
          await sendRequest(method: 'PUT', endPoint: endPoint, data: data);
      return fromJson != null ? fromJson(response) : response as T;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<T> patch<T>({
    required String endPoint,
    Map<String, dynamic>? data,
    Map<String, dynamic>? files,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      if (!await isInternetAvailable()) throw SocketException("No Internet");
      if (!await isServerAvailable(
        endPoint: endPoint,
        queryParameters: {'id': data?['id']},
      )) {
        throw Exception("Server is down");
      }
      final response =
          await sendRequest(method: 'PATCH', endPoint: endPoint, data: data);
      return fromJson != null ? fromJson(response) : response as T;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<T> delete<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      if (!await isInternetAvailable()) throw SocketException("No Internet");
      if (!await isServerAvailable(
        endPoint: endPoint,
        queryParameters: queryParameters,
      )) {
        throw Exception("Server is down");
      }
      final response = await sendRequest(
        method: 'DELETE',
        endPoint: endPoint,
        queryParameters: queryParameters,
      );
      if (response.isEmpty) return Future.value();
      return response as T;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  @override
  Future<http.Response> head({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
  }) async {
    final uri = buildUri(endPoint, queryParameters: queryParameters);
    final prefs = await SharedPreferences.getInstance();
    final storedEtag = prefs.getString('etag_$uri');
    final requestHeaders = Map<String, String>.from(headers);
    if (storedEtag != null) {
      requestHeaders['If-None-Match'] = storedEtag;
      requestHeaders['If-Match'] = storedEtag;
    }

    try {
      final response = await http.head(uri, headers: requestHeaders);
      if (response.headers.containsKey('etag')) {
        await prefs.setString('etag_$uri', response.headers['etag']!);
      }
      return response;
    } catch (e) {
      handleError(e as Exception);
      rethrow;
    }
  }

  Map<String, dynamic> _processResponse(http.Response response) {
    if (response.statusCode == 204 || response.body.isEmpty) return {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) return decoded;
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Invalid JSON: ${response.body}');
    }
  }

  void search(String query, Function(Map<String, dynamic>) onResult) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final result =
            await get(endPoint: 'search', queryParameters: {'q': query});
        onResult(result);
      } catch (e) {
        handleError(e as Exception);
      }
    });
  }

  Future<Map<String, dynamic>> _getCachedData(
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
    throw SocketException("No Internet and no valid cache available");
  }

  Future<void> _cacheData(SharedPreferences prefs, String cacheKey,
      Map<String, dynamic> data) async {
    await prefs.setString(
        cacheKey,
        jsonEncode({
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'data': data,
        }));
    debugPrint('🟢 [Online] Fetched & cached $cacheKey');
  }
}
