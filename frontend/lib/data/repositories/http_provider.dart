import 'package:flutter/material.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nutriai_app/data/repositories/api_provider.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:nutriai_app/exception/server_exception.dart';

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
  Future<bool> isServerAvailable(dynamic response) async {
    try {
      if (response is http.Response || response is dio.Response) {
        if (response.statusCode > 500) {
          throw ServerException(
              message: 'Server error!', statusCode: response.statusCode);
        }
      } else if (response is dio.DioException) {
        switch (response.type) {
          case dio.DioExceptionType.unknown:
          case dio.DioExceptionType.connectionTimeout:
          case dio.DioExceptionType.receiveTimeout:
          case dio.DioExceptionType.sendTimeout:
          case dio.DioExceptionType.badResponse:
          case dio.DioExceptionType.cancel:
          case dio.DioExceptionType.badCertificate:
          case dio.DioExceptionType.connectionError:
            return false;
        }
      }
      return true;
    } catch (e) {
      debugPrint('Error checking server availability: $e');
      return false;
    }
  }

  @override
  void handleError(Exception e) {
    if (e is SocketException) {
      debugPrint("Please check your internet connection.");
    } else {
      debugPrint("⚠️ [Error] $e");
    }
  }
}
