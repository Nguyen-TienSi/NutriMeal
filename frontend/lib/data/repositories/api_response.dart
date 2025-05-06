class ApiResponse {
  final dynamic data;
  final String? message;

  ApiResponse({this.data, this.message});

  factory ApiResponse.fromResponse(dynamic response) {
    if (response == null) return ApiResponse.withError('No data found');

    if (response is Map<String, dynamic>) {
      if (response.containsKey('data') && response['data'] != null) {
        return ApiResponse(data: response['data']);
      } else {
        return ApiResponse.withError(response['title'] ?? 'No data found');
      }
    }

    return ApiResponse.withError('Invalid response format');
  }

  factory ApiResponse.withError(String message) {
    return ApiResponse(message: message);
  }
}
