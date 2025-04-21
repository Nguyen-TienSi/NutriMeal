class ApiResponse {
  final bool success;
  final dynamic data;
  final String? message;

  ApiResponse({required this.success, this.data, this.message});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'] ?? false,
      data: json['data'],
      message: json['message'],
    );
  }

  factory ApiResponse.withError(String error) {
    return ApiResponse(success: false, message: error);
  }
}
