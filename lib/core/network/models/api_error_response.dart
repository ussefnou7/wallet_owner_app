class ApiErrorResponse {
  const ApiErrorResponse({
    this.timestamp,
    this.status,
    this.code,
    this.message,
    this.path,
    this.details,
    this.traceId,
  });

  final String? timestamp;
  final int? status;
  final String? code;
  final String? message;
  final String? path;
  final Object? details;
  final String? traceId;

  factory ApiErrorResponse.fromJson(Map<String, dynamic> json) {
    return ApiErrorResponse(
      timestamp: _asString(json['timestamp']),
      status: _asInt(json['status']),
      code: _asString(json['code']),
      message: _asString(json['message']),
      path: _asString(json['path']),
      details: json['details'],
      traceId: _asString(json['traceId']),
    );
  }

  static int? _asInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }

  static String? _asString(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
    return null;
  }
}
