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

  Future<ApiResponse> sendData({
    required String endPoint,
    var data,
    var files,
  }) async {
    try {
      return await apiProvider.post<ApiResponse>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> updateData({
    required String endPoint,
    var data,
    var files,
  }) async {
    try {
      return await apiProvider.put<ApiResponse>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> patchData({
    required String endPoint,
    var data,
    var files,
  }) async {
    try {
      return await apiProvider.patch<ApiResponse>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future deleteData({
    required String endPoint,
    Map<String, dynamic>? params,
  }) async {
    try {
      await apiProvider.delete(endPoint: endPoint, queryParameters: params);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }
}
