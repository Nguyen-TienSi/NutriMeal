import 'package:nutriai_app/exception/unnamed_exception.dart'
    show UnnamedException;

import 'api_provider.dart';
import 'api_response.dart' show ApiResponse;

class ApiRepository {
  final ApiProvider apiProvider;

  ApiRepository({required this.apiProvider});

  Future<T> fetchData<T>({
    required String endPoint,
    Map<String, dynamic>? params,
    required T Function(dynamic data) fromJson,
  }) async {
    try {
      final response = await apiProvider.get<dynamic>(
          endPoint: endPoint, queryParameters: params);

      final apiResponse = ApiResponse.fromResponse(response);

      if (apiResponse.message == null) {
        return fromJson(apiResponse.data);
      } else {
        throw UnnamedException(apiResponse.message!);
      }
    } catch (e) {
      throw UnnamedException(e.toString());
    }
  }

  Future<T?> sendData<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await apiProvider.post<dynamic>(
          endPoint: endPoint, data: data, files: files);

      final apiResponse = ApiResponse.fromResponse(response);
      if (apiResponse.message == null) {
        return fromJson?.call(apiResponse.data);
      } else {
        throw UnnamedException(apiResponse.message!);
      }
    } catch (e) {
      throw UnnamedException(e.toString());
    }
  }

  Future<T?> updateData<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await apiProvider.put<dynamic>(
          endPoint: endPoint, data: data, files: files);
      final apiResponse = ApiResponse.fromResponse(response);
      if (apiResponse.message == null) {
        return fromJson?.call(apiResponse.data);
      } else {
        throw UnnamedException(apiResponse.message!);
      }
    } catch (e) {
      throw UnnamedException(e.toString());
    }
  }

  Future<T?> patchData<T>({
    required String endPoint,
    var data,
    var files,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await apiProvider.patch<dynamic>(
          endPoint: endPoint, data: data, files: files);
      final apiResponse = ApiResponse.fromResponse(response);
      if (apiResponse.message == null) {
        return fromJson?.call(apiResponse.data);
      } else {
        throw UnnamedException(apiResponse.message!);
      }
    } catch (e) {
      throw UnnamedException(e.toString());
    }
  }

  Future<T?> deleteData<T>({
    required String endPoint,
    Map<String, dynamic>? params,
    T Function(dynamic data)? fromJson,
  }) async {
    try {
      final response = await apiProvider.delete<dynamic>(
          endPoint: endPoint, queryParameters: params);
      final apiResponse = ApiResponse.fromResponse(response);
      if (apiResponse.message == null) {
        return fromJson?.call(apiResponse.data);
      } else {
        throw UnnamedException(apiResponse.message!);
      }
    } catch (e) {
      throw UnnamedException(e.toString());
    }
  }
}
