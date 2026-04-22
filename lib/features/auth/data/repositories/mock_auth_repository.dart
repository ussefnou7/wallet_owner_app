import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../services/session_local_data_source.dart';

class MockAuthRepository implements AuthRepository {
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
      accessToken: 'mock-owner-token',
      refreshToken: 'mock-refresh-token',
      username: username,
      role: UserRole.owner,
      backendRole: 'OWNER',
      tenantId: 'tenant-demo',
      userId: username,
      displayName: 'Owner User',
    );
    await _localDataSource.saveSession(session);
    return session;
  }

  @override
  Future<void> logout() {
    return _localDataSource.clearSession();
  }
}
