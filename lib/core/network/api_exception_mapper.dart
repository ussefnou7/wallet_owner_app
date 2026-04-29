import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_exception.dart';
import 'models/api_error_response.dart';

final apiExceptionMapperProvider = Provider<ApiExceptionMapper>(
  (ref) => const ApiExceptionMapper(),
);

class ApiExceptionMapper {
  const ApiExceptionMapper();

  AppException map(Object error) {
    if (error is AppException) {
      _logException(error);
      return error;
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    final appException = AppException(
      code: 'UNKNOWN_ERROR',
      message: '$error',
    );
    _logException(appException);
    return appException;
  }

  AppException _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final backendError = _parseBackendError(error.response?.data);

    if (backendError != null) {
      return _mapStructuredError(backendError, fallbackStatus: statusCode);
    }

    final appException = switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => AppException(
        code: 'NETWORK_TIMEOUT',
        message: 'The request timed out. Please try again.',
        status: statusCode,
      ),
      DioExceptionType.badResponse => _mapBadResponse(
        statusCode: statusCode,
        responseMessage: _responseMessage(error.response?.data),
      ),
      DioExceptionType.cancel => const AppException(
        code: 'NETWORK_ERROR',
        message: 'The request was cancelled.',
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => AppException(
        code: 'NETWORK_ERROR',
        message:
            'Unable to connect right now. Check your network and try again.',
        status: statusCode,
      ),
      DioExceptionType.unknown => AppException(
        code: 'UNKNOWN_ERROR',
        message:
            _responseMessage(error.response?.data) ??
            'Unexpected network error. Please try again.',
        status: statusCode,
      ),
    };
    _logException(appException);
    return appException;
  }

  AppException _mapStructuredError(
    ApiErrorResponse error, {
    required int? fallbackStatus,
  }) {
    final status = error.status ?? fallbackStatus;
    final appException = AppException(
      code: error.code ?? _fallbackCode(status),
      message: error.message ?? _fallbackMessage(status),
      status: status,
      details: error.details,
      traceId: error.traceId,
    );
    _logException(appException);
    return appException;
  }

  AppException _mapBadResponse({
    required int? statusCode,
    String? responseMessage,
  }) {
    final appException = AppException(
      code: _fallbackCode(statusCode),
      message: responseMessage ?? _fallbackMessage(statusCode),
      status: statusCode,
    );
    _logException(appException);
    return appException;
  }

  ApiErrorResponse? _parseBackendError(Object? data) {
    final map = _asJsonMap(data);
    if (map == null) {
      return null;
    }

    final hasBackendContract = [
      'timestamp',
      'status',
      'code',
      'message',
      'path',
      'details',
      'traceId',
    ].any(map.containsKey);

    if (!hasBackendContract) {
      return null;
    }

    return ApiErrorResponse.fromJson(map);
  }

  String? _responseMessage(Object? data) {
    final map = _asJsonMap(data);
    if (map != null) {
      final message = map['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      final error = map['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return null;
  }

  Map<String, dynamic>? _asJsonMap(Object? data) {
    if (data is Map) {
      try {
        return Map<String, dynamic>.from(data);
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  String _fallbackCode(int? statusCode) {
    return switch (statusCode) {
      400 || 422 => 'BAD_REQUEST',
      401 => 'UNAUTHORIZED',
      403 => 'FORBIDDEN',
      404 => 'ENTITY_NOT_FOUND',
      final int code when code >= 500 => 'INTERNAL_SERVER_ERROR',
      _ => 'UNKNOWN_ERROR',
    };
  }

  String _fallbackMessage(int? statusCode) {
    return switch (statusCode) {
      400 || 422 => 'The request could not be processed.',
      401 => 'Your session has expired. Please sign in again.',
      403 => 'You do not have permission to perform this action.',
      404 => 'The requested item could not be found.',
      final int code when code >= 500 =>
        'The server is unavailable right now. Please try again.',
      _ => 'Something went wrong. Please try again.',
    };
  }

  void _logException(AppException exception) {
    developer.log(
      'API error code=${exception.code} status=${exception.status} '
      'message="${exception.message}" traceId=${exception.traceId ?? '-'}',
      name: 'api_exception_mapper',
      level: 800,
    );
  }
}
