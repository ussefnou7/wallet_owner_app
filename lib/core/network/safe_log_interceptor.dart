import 'dart:developer' as developer;

import 'package:dio/dio.dart';

/// Safe logging interceptor that redacts sensitive data.
/// Prevents tokens, passwords, and personal information from appearing in logs.
class SafeLogInterceptor extends Interceptor {
  SafeLogInterceptor({
    this.logRequestBody = true,
    this.logResponseBody = true,
    this.redactedFields = const {
      'authorization',
      'password',
      'token',
      'accessToken',
      'refreshToken',
      'phoneNumber',
      'email',
      'ssn',
      'creditCard',
    },
  });

  final bool logRequestBody;
  final bool logResponseBody;
  final Set<String> redactedFields;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _logRequest(options);
    handler.next(options);
  }

  @override
  Future<void> onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) async {
    _logResponse(response);
    handler.next(response);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    _logError(err);
    handler.next(err);
  }

  void _logRequest(RequestOptions options) {
    final buffer = StringBuffer();
    buffer.writeln('→ Request: ${options.method} ${options.baseUrl}${options.path}');

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('  Query: ${_redactMap(options.queryParameters)}');
    }

    if (logRequestBody && options.data != null) {
      final safeData = _redactData(options.data);
      buffer.writeln('  Body: $safeData');
    }

    developer.log(
      buffer.toString(),
      name: 'dio.http',
      level: 800, // Info level
    );
  }

  void _logResponse(Response<dynamic> response) {
    final buffer = StringBuffer();
    buffer.writeln(
      '← Response: ${response.statusCode} ${response.requestOptions.method} '
      '${response.requestOptions.path}',
    );

    if (logResponseBody && response.data != null) {
      final safeData = _redactData(response.data);
      buffer.writeln('  Body: $safeData');
    }

    developer.log(
      buffer.toString(),
      name: 'dio.http',
      level: 800,
    );
  }

  void _logError(DioException error) {
    final buffer = StringBuffer();
    buffer.writeln('✗ Error: ${error.type} (${error.response?.statusCode})');
    buffer.writeln('  ${error.message}');

    if (error.response?.data != null) {
      final safeData = _redactData(error.response!.data);
      buffer.writeln('  Response: $safeData');
    }

    developer.log(
      buffer.toString(),
      name: 'dio.http',
      level: 900, // Warning level
    );
  }

  Object? _redactData(Object? data) {
    if (data is Map<String, dynamic>) {
      return _redactMap(data);
    } else if (data is List) {
      return _redactList(data);
    }
    return data;
  }

  Map<String, dynamic> _redactMap(Map<String, dynamic> map) {
    return map.map((key, value) {
      final lowerKey = key.toLowerCase();
      if (_isRedacted(lowerKey)) {
        return MapEntry(key, '***REDACTED***');
      }
      return MapEntry(key, _redactData(value));
    });
  }

  List<Object?> _redactList(List list) {
    return list.map(_redactData).toList();
  }

  bool _isRedacted(String fieldName) {
    return redactedFields.any((field) => fieldName.contains(field));
  }
}
