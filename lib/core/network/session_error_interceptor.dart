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
    onSubscriptionExpired: authController.handleSubscriptionExpired,
  );
});

class SessionErrorInterceptor extends Interceptor {
  SessionErrorInterceptor({
    required ApiExceptionMapper exceptionMapper,
    required Future<void> Function(AppException exception) onSessionInvalidated,
    required Future<void> Function(AppException exception)
    onSubscriptionExpired,
  }) : _exceptionMapper = exceptionMapper,
       _onSessionInvalidated = onSessionInvalidated,
       _onSubscriptionExpired = onSubscriptionExpired;

  final ApiExceptionMapper _exceptionMapper;
  final Future<void> Function(AppException exception) _onSessionInvalidated;
  final Future<void> Function(AppException exception) _onSubscriptionExpired;
  Future<void>? _activeSessionInvalidation;
  Future<void>? _activeSubscriptionExpiredHandling;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final exception = _exceptionMapper.map(err);

    if (exception.isSubscriptionExpired) {
      if (_activeSubscriptionExpiredHandling == null) {
        final completer = Completer<void>();
        _activeSubscriptionExpiredHandling = completer.future;
        unawaited(() async {
          try {
            await _onSubscriptionExpired(exception);
            completer.complete();
          } catch (error, stackTrace) {
            completer.completeError(error, stackTrace);
          } finally {
            if (identical(
              _activeSubscriptionExpiredHandling,
              completer.future,
            )) {
              _activeSubscriptionExpiredHandling = null;
            }
          }
        }());
      }
      try {
        await _activeSubscriptionExpiredHandling;
      } catch (_) {
        // Subscription state sync failed, but the original request error should still propagate.
      }
    } else if (exception.requiresSessionInvalidation) {
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
