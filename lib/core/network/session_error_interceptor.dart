import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/domain/repositories/auth_repository.dart';

final sessionErrorInterceptorProvider = Provider<SessionErrorInterceptor>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return SessionErrorInterceptor(logout: authRepository.logout);
});

class SessionErrorInterceptor extends Interceptor {
  SessionErrorInterceptor({required Future<void> Function() logout})
    : _logout = logout;

  final Future<void> Function() _logout;
  bool _isLoggingOut = false;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    if (statusCode == 401 && !_isLoggingOut) {
      _isLoggingOut = true;
      try {
        await _logout();
      } catch (_) {
        // Logout failed, but we still want to pass the error to the app
      } finally {
        _isLoggingOut = false;
      }
    }

    handler.next(err);
  }
}
