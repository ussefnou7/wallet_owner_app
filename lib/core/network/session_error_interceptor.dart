import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../errors/app_exception.dart';
import 'api_exception_mapper.dart';

final sessionErrorInterceptorProvider = Provider<SessionErrorInterceptor>((
  ref,
) {
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  final authController = ref.watch(authControllerProvider.notifier);
  return SessionErrorInterceptor(
    exceptionMapper: exceptionMapper,
    onSessionInvalidated: authController.handleSessionInvalidation,
  );
});

class SessionErrorInterceptor extends Interceptor {
  SessionErrorInterceptor({
    required ApiExceptionMapper exceptionMapper,
    required Future<void> Function(AppException exception) onSessionInvalidated,
  }) : _exceptionMapper = exceptionMapper,
       _onSessionInvalidated = onSessionInvalidated;

  final ApiExceptionMapper _exceptionMapper;
  final Future<void> Function(AppException exception) _onSessionInvalidated;
  Future<void>? _activeSessionInvalidation;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final exception = _exceptionMapper.map(err);

    if (exception.requiresSessionInvalidation) {
      if (_activeSessionInvalidation == null) {
        final completer = Completer<void>();
        _activeSessionInvalidation = completer.future;
        unawaited(() async {
          try {
            await _onSessionInvalidated(exception);
            completer.complete();
          } catch (error, stackTrace) {
            completer.completeError(error, stackTrace);
          } finally {
            if (identical(_activeSessionInvalidation, completer.future)) {
              _activeSessionInvalidation = null;
            }
          }
        }());
      }
      try {
        await _activeSessionInvalidation;
      } catch (_) {
        // Session cleanup failed, but we still want to pass the error to the app.
      }
    }

    handler.next(err);
  }
}
