import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/session_local_data_source.dart';

class MockAuthRepository implements AuthRepository {
  static const _mockOwnerToken =
      'header.'
      'eyJzdWIiOiJtb2NrLW93bmVyIiwicm9sZSI6Ik9XTkVSIiwidGVuYW50SWQiOiJ0ZW5hbnQtZGVtbyIsInVzZXJJZCI6Im1vY2stb3duZXIiLCJleHAiOjI1MjQ2MDgwMDB9.'
      'signature';

  MockAuthRepository(this._localDataSource);

  final SessionLocalDataSource _localDataSource;

  @override
  Future<Session?> getCurrentSession() {
    return _localDataSource.readSession();
  }

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    final session = Session(
      accessToken: _mockOwnerToken,
      refreshToken: 'mock-refresh-token',
      username: username,
      role: UserRole.owner,
      backendRole: 'OWNER',
      tenantId: 'tenant-demo',
      tenantName: 'BTC Workspace',
      userId: username,
      displayName: 'Owner User',
    );
    await _localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<String?> forgotPassword({required String username}) async {
    return null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<void> logout() {
    return _localDataSource.clearSession();
  }
}
