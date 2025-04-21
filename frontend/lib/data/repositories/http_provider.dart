import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nutriai_app/data/repositories/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;

abstract class HttpProvider implements ApiProvider {
  @override
  Future<bool> isInternetAvailable() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }

  @override
  Future<bool> isServerAvailable({
    String endPoint = 'health',
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response =
          await head(endPoint: endPoint, queryParameters: queryParameters);

      if (response is http.Response || response is dio.Response) {
        return [200, 204, 304].contains(response.statusCode);
      }

      return false;
    } catch (e) {
      debugPrint("Error checking server availability: $e");
      return false;
    }
  }

  @override
  void handleError(Exception e) {
    if (e is SocketException) {
      debugPrint("Please check your internet connection.");
    } else {
      debugPrint("An error occurred: $e");
    }
  }
}
