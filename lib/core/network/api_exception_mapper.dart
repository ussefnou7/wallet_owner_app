import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../errors/app_failure.dart';

final apiExceptionMapperProvider = Provider<ApiExceptionMapper>(
  (ref) => const ApiExceptionMapper(),
);

class ApiExceptionMapper {
  const ApiExceptionMapper();

  AppFailure map(Object error) {
    if (error is AppFailureException) {
      return error.failure;
    }

    if (error is DioException) {
      return _mapDioException(error);
    }

    return const UnknownFailure('Something went wrong. Please try again.');
  }

  AppFailure _mapDioException(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseMessage = _responseMessage(error.response?.data);

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => TimeoutFailure(
        responseMessage ?? 'The request timed out. Please try again.',
        statusCode: statusCode,
      ),
      DioExceptionType.badResponse => _mapBadResponse(
        statusCode: statusCode,
        message: responseMessage,
      ),
      DioExceptionType.cancel => const NetworkFailure(
        'The request was cancelled.',
      ),
      DioExceptionType.connectionError ||
      DioExceptionType.badCertificate => NetworkFailure(
        responseMessage ??
            'Unable to connect right now. Check your network and try again.',
        statusCode: statusCode,
      ),
      DioExceptionType.unknown => UnknownFailure(
        responseMessage ?? 'Unexpected network error. Please try again.',
        statusCode: statusCode,
      ),
    };
  }

  AppFailure _mapBadResponse({required int? statusCode, String? message}) {
    if (statusCode == 401 || statusCode == 403) {
      return UnauthorizedFailure(
        message ?? 'Your session is not authorized. Please sign in again.',
        statusCode: statusCode,
      );
    }

    if (statusCode == 400 || statusCode == 422) {
      return ValidationFailure(
        message ?? 'The request could not be processed.',
        statusCode: statusCode,
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return ServerFailure(
        message ?? 'The server is unavailable right now. Please try again.',
        statusCode: statusCode,
      );
    }

    return NetworkFailure(
      message ?? 'Request failed. Please try again.',
      statusCode: statusCode,
    );
  }

  String? _responseMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      // Try to get message first (most specific)
      var message = data['message'];
      if (message is String && message.trim().isNotEmpty) {
        return message.trim();
      }

      // Fall back to error field (more general)
      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) {
        return error.trim();
      }
    }

    return null;
  }
}
