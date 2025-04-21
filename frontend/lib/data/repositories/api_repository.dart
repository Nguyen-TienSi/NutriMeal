import 'api_provider.dart';

class ApiRepository {
  final ApiProvider apiProvider;

  ApiRepository({required this.apiProvider});

  Future<Map<String, dynamic>> fetchData(
      {required String endPoint, Map<String, dynamic>? params}) async {
    try {
      return await apiProvider.get<Map<String, dynamic>>(
          endPoint: endPoint, queryParameters: params);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> sendData(
      {required String endPoint, Map<String, dynamic>? data, files}) async {
    try {
      return await apiProvider.post<Map<String, dynamic>>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateData(
      {required String endPoint, Map<String, dynamic>? data, files}) async {
    try {
      return await apiProvider.put<Map<String, dynamic>>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> patchData(
      {required String endPoint, Map<String, dynamic>? data, files}) async {
    try {
      return await apiProvider.patch<Map<String, dynamic>>(
          endPoint: endPoint, data: data, files: files);
    } catch (e) {
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteData(
      {required String endPoint, Map<String, dynamic>? params}) async {
    try {
      return await apiProvider.delete(
          endPoint: endPoint, queryParameters: params);
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
