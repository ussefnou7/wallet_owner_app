import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/core/errors/app_exception.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  test('signIn resets session-scoped state before authenticating', () async {
    final repository = _FakeAuthRepository();
    var resetCalls = 0;
    final controller = AuthController(
      authRepository: repository,
      resetSessionScope: () async {
        resetCalls += 1;
      },
    );

    await controller.signIn(username: 'owner1', password: 'secret123');

    expect(resetCalls, 1);
    expect(controller.state.status, AuthStatus.authenticated);
    expect(controller.state.session?.tenantId, 'tenant-1');
    expect(repository.loginCalls, 1);
  });

  test('signOut clears auth state and resets session-scoped state', () async {
    final repository = _FakeAuthRepository();
    var resetCalls = 0;
    final controller = AuthController(
      authRepository: repository,
      initialSession: repository.session,
      resetSessionScope: () async {
        resetCalls += 1;
      },
    );

    await controller.signOut();

    expect(repository.logoutCalls, 1);
    expect(resetCalls, 1);
    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(controller.state.session, isNull);
  });

  test('session invalidation logout also resets session-scoped state', () async {
    final repository = _FakeAuthRepository();
    var resetCalls = 0;
    final controller = AuthController(
      authRepository: repository,
      initialSession: repository.session,
      resetSessionScope: () async {
        resetCalls += 1;
      },
    );

    await controller.handleSessionInvalidation(
      const AppException(
        code: 'TOKEN_EXPIRED',
        message: 'Token expired',
        status: 401,
      ),
    );

    expect(repository.logoutCalls, 1);
    expect(resetCalls, 1);
    expect(controller.state.status, AuthStatus.unauthenticated);
    expect(controller.state.error?.code, 'TOKEN_EXPIRED');
  });
}

class _FakeAuthRepository implements AuthRepository {
  final Session session = const Session(
    accessToken: 'token-1',
    refreshToken: 'refresh-1',
    username: 'owner1',
    role: UserRole.owner,
    backendRole: 'OWNER',
    tenantId: 'tenant-1',
    userId: 'user-1',
    displayName: 'Owner One',
  );

  int loginCalls = 0;
  int logoutCalls = 0;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<String?> forgotPassword({required String username}) async => null;

  @override
  Future<Session?> getCurrentSession() async => session;

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    loginCalls += 1;
    return session;
  }

  @override
  Future<void> logout() async {
    logoutCalls += 1;
  }

  @override
  Future<Session> refreshSession({Session? currentSession}) async {
    return currentSession ?? session;
  }

  @override
  Future<void> saveSession(Session session) async {}
}
