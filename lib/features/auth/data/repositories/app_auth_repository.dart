import '../../../../core/config/app_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_model.dart';
import '../services/auth_mock_data_source.dart';
import '../services/auth_remote_data_source.dart';
import '../services/session_local_data_source.dart';

class AppAuthRepository implements AuthRepository {
  AppAuthRepository({
    required AppConfig config,
    required SessionLocalDataSource sessionLocalDataSource,
    required AuthMockDataSource mockDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) : _config = config,
       _sessionLocalDataSource = sessionLocalDataSource,
       _mockDataSource = mockDataSource,
       _remoteDataSource = remoteDataSource;

  final AppConfig _config;
  final SessionLocalDataSource _sessionLocalDataSource;
  final AuthMockDataSource _mockDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Session?> getCurrentSession() {
    return _sessionLocalDataSource.readSession();
  }

  @override
  Future<Session> login({
    required String email,
    required String password,
  }) async {
    final request = LoginRequestModel(email: email, password: password);
    final result = _config.useMockAuth
        ? await _mockDataSource.login(request)
        : await _remoteDataSource.login(request);

    return result.when(
      success: (response) async {
        final session = response.toSession();
        await _sessionLocalDataSource.saveSession(session);
        return session;
      },
      failure: (failure) => throw AppFailureException(failure),
    );
  }

  @override
  Future<void> logout() {
    return _sessionLocalDataSource.clearSession();
  }
}
