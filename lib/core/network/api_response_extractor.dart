import 'dart:developer' as developer;

import '../errors/app_failure.dart';

/// Utility for extracting and validating API response data.
/// Ensures consistent handling across all remote data sources.
abstract final class ApiResponseExtractor {
  /// Extracts a single object from response payload.
  /// Handles nested data structures and logging.
  static Map<String, dynamic> extractObject(Object? payload) {
    if (payload is Map<String, dynamic>) {
      for (final key in const ['data', 'content', 'item', 'result']) {
        final value = payload[key];
        if (value is Map<String, dynamic>) {
          _log('Extracted object from nested key: $key');
          return extractObject(value);
        }
      }
      return payload;
    }

    _logError('Expected Map object, got ${payload.runtimeType}');
    throw const AppFailureException(
      UnknownFailure('Unexpected API response structure.'),
    );
  }

  /// Extracts a list from response payload.
  /// Handles wrapped lists in nested structures.
  static List<Map<String, dynamic>> extractList(Object? payload) {
    final listPayload = switch (payload) {
      final List<Object?> value => value,
      final Map<String, dynamic> value => _unwrapList(value),
      _ => null,
    };

    if (listPayload == null) {
      _logError('Response does not contain list: got ${payload.runtimeType}');
      throw const AppFailureException(
        UnknownFailure(
          'Unexpected API response format. Expected list or wrapped list.',
        ),
      );
    }

    final items = listPayload.whereType<Map<String, dynamic>>().toList();
    _log('Extracted list with ${items.length} items');
    return items;
  }

  /// Validates response status code.
  /// Throws if status indicates error.
  static void validateStatus(int? statusCode) {
    if (statusCode == null) {
      return; // Status code might be null in some cases
    }

    if (statusCode < 200 || statusCode >= 300) {
      _logError('Invalid status code: $statusCode');
      throw const AppFailureException(
        UnknownFailure('Invalid response status code.'),
      );
    }
  }

  /// Validates response body is not empty.
  static void validateNotEmpty(Object? data) {
    if (data == null) {
      _logError('Response body is empty (null)');
      throw const AppFailureException(
        UnknownFailure('Server returned empty response.'),
      );
    }
  }

  static List<Object?>? _unwrapList(Map<String, dynamic> payload) {
    for (final key in const ['data', 'content', 'items', 'results']) {
      final value = payload[key];
      if (value is List<Object?>) {
        _log('Unwrapped list from key: $key');
        return value;
      }
      if (value is Map<String, dynamic>) {
        final nested = _unwrapList(value);
        if (nested != null) {
          return nested;
        }
      }
    }
    return null;
  }

  static void _log(String message) {
    developer.log('[API] $message', name: 'api_response_extractor');
  }

  static void _logError(String message) {
    developer.log('[API ERROR] $message', name: 'api_response_extractor');
  }
}
