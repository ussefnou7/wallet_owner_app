import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/login_request_model.dart';
import '../services/auth_remote_data_source.dart';
import '../services/session_local_data_source.dart';

class AppAuthRepository implements AuthRepository {
  AppAuthRepository({
    required SessionLocalDataSource sessionLocalDataSource,
    required AuthRemoteDataSource remoteDataSource,
  }) : _sessionLocalDataSource = sessionLocalDataSource,
       _remoteDataSource = remoteDataSource;

  final SessionLocalDataSource _sessionLocalDataSource;
  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Session?> getCurrentSession() {
    return _sessionLocalDataSource.readSession();
  }

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    final request = LoginRequestModel(username: username, password: password);
    final result = await _remoteDataSource.login(request);

    return result.when(
      success: (response) async {
        final session = response.toSession();
        await _sessionLocalDataSource.saveSession(session);
        return session;
      },
      failure: (failure) => throw AppFailureException(switch (failure) {
        UnauthorizedFailure() => UnauthorizedFailure(
          'Invalid username or password.',
          statusCode: failure.statusCode,
        ),
        _ => failure,
      }),
    );
  }

  @override
  Future<void> logout() {
    return _sessionLocalDataSource.clearSession();
  }
}
