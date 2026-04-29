import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../errors/app_exception.dart';
import 'api_exception_mapper.dart';

final sessionErrorInterceptorProvider = Provider<SessionErrorInterceptor>((ref) {
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  final authController = ref.watch(authControllerProvider.notifier);
  return SessionErrorInterceptor(
    exceptionMapper: exceptionMapper,
    onUnauthorized: authController.handleUnauthorized,
  );
});

class SessionErrorInterceptor extends Interceptor {
  SessionErrorInterceptor({
    required ApiExceptionMapper exceptionMapper,
    required Future<void> Function(AppException exception) onUnauthorized,
  }) : _exceptionMapper = exceptionMapper,
       _onUnauthorized = onUnauthorized;

  final ApiExceptionMapper _exceptionMapper;
  final Future<void> Function(AppException exception) _onUnauthorized;
  bool _isLoggingOut = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final exception = _exceptionMapper.map(err);

    if (exception.isUnauthorized && !_isLoggingOut) {
      _isLoggingOut = true;
      try {
        await _onUnauthorized(exception);
      } catch (_) {
        // Session cleanup failed, but we still want to pass the error to the app.
      } finally {
        _isLoggingOut = false;
      }
    }

    handler.next(err);
  }
}
