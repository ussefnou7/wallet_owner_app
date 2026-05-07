import '../../domain/entities/session.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/forgot_password_request_model.dart';
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
        if (session.hasSubscriptionData) {
          return session;
        }

        try {
          return await refreshSession(currentSession: session);
        } catch (_) {
          return session;
        }
      },
      failure: (failure) => throw failure,
    );
  }

  @override
  Future<Session> refreshSession({Session? currentSession}) async {
    final baseSession =
        currentSession ?? await _sessionLocalDataSource.readSession();
    if (baseSession == null) {
      throw const FormatException('No session available to refresh');
    }

    final result = await _remoteDataSource.getCurrentSession(baseSession);
    return result.when(
      success: (session) async {
        await _sessionLocalDataSource.saveSession(session);
        return session;
      },
      failure: (failure) => throw failure,
    );
  }

  @override
  Future<void> saveSession(Session session) {
    return _sessionLocalDataSource.saveSession(session);
  }

  @override
  Future<String?> forgotPassword({required String username}) async {
    final request = ForgotPasswordRequestModel(username: username);
    final result = await _remoteDataSource.forgotPassword(request);

    return result.when(
      success: (response) async => response.responseMessage,
      failure: (failure) => throw failure,
    );
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _remoteDataSource.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );

    return result.when(
      success: (_) async {},
      failure: (failure) => throw failure,
    );
  }

  @override
  Future<void> logout() {
    return _sessionLocalDataSource.clearSession();
  }
}
