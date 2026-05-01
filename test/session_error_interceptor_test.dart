import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/core/errors/app_exception.dart';
import 'package:wallet_owner_app/core/network/api_exception_mapper.dart';
import 'package:wallet_owner_app/core/network/session_error_interceptor.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  test(
    'triggers only one forced logout for concurrent TOKEN_EXPIRED errors',
    () async {
      final logoutGate = Completer<void>();
      final repository = _FakeAuthRepository(logoutGate: logoutGate);
      final authController = AuthController(
        authRepository: repository,
        initialSession: const Session(
          accessToken: 'token',
          refreshToken: '',
          username: 'owner@example.com',
          role: UserRole.owner,
          backendRole: 'OWNER',
          tenantId: 'tenant-demo',
          userId: 'user-1',
          displayName: 'Owner User',
        ),
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _FakeAdapter(
        (options) => ResponseBody.fromString(
          '{"status":401,"code":"TOKEN_EXPIRED","message":"Token expired"}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      dio.interceptors.add(
        SessionErrorInterceptor(
          exceptionMapper: const ApiExceptionMapper(),
          onSessionInvalidated: authController.handleSessionInvalidation,
        ),
      );

      final firstRequest = () async {
        try {
          await dio.get('/wallets');
        } catch (_) {}
      }();
      final secondRequest = () async {
        try {
          await dio.get('/branches');
        } catch (_) {}
      }();

      await repository.logoutStarted.future.timeout(const Duration(seconds: 1));
      expect(repository.logoutCalls, 1);

      logoutGate.complete();
      await Future.wait([firstRequest, secondRequest]);
      expect(repository.logoutCalls, 1);
      expect(authController.state.status, AuthStatus.unauthenticated);
      expect(authController.state.error?.code, 'TOKEN_EXPIRED');
    },
  );

  test(
    'forces logout for ACCOUNT_INACTIVE but not generic FORBIDDEN',
    () async {
      var logoutCalls = 0;
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = _FakeAdapter((options) {
        if (options.path == '/inactive') {
          return ResponseBody.fromString(
            '{"status":403,"code":"ACCOUNT_INACTIVE","message":"Disabled"}',
            403,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        return ResponseBody.fromString(
          '{"status":403,"code":"FORBIDDEN","message":"Forbidden"}',
          403,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      });
      dio.interceptors.add(
        SessionErrorInterceptor(
          exceptionMapper: const ApiExceptionMapper(),
          onSessionInvalidated: (exception) async {
            logoutCalls += 1;
            expect(
              exception,
              const AppException(
                code: 'ACCOUNT_INACTIVE',
                message: 'Disabled',
                status: 403,
              ),
            );
          },
        ),
      );

      await expectLater(dio.get('/inactive'), throwsA(isA<DioException>()));
      await expectLater(dio.get('/forbidden'), throwsA(isA<DioException>()));

      expect(logoutCalls, 1);
    },
  );
}

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this._handler);

  final ResponseBody Function(RequestOptions options) _handler;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    return _handler(options);
  }

  @override
  void close({bool force = false}) {}
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({required this.logoutGate});

  final Completer<void> logoutGate;
  final Completer<void> logoutStarted = Completer<void>();
  int logoutCalls = 0;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Session?> getCurrentSession() {
    throw UnimplementedError();
  }

  @override
  Future<Session> login({required String username, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {
    logoutCalls += 1;
    if (!logoutStarted.isCompleted) {
      logoutStarted.complete();
    }
    await logoutGate.future;
  }
}
