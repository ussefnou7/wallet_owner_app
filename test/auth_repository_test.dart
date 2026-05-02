import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ta2feela_app/core/errors/app_exception.dart';
import 'package:ta2feela_app/core/network/api_result.dart';
import 'package:ta2feela_app/core/storage/app_secure_storage.dart';
import 'package:ta2feela_app/features/auth/data/models/forgot_password_request_model.dart';
import 'package:ta2feela_app/features/auth/data/models/forgot_password_response_model.dart';
import 'package:ta2feela_app/features/auth/data/models/login_request_model.dart';
import 'package:ta2feela_app/features/auth/data/models/login_response_model.dart';
import 'package:ta2feela_app/features/auth/data/repositories/app_auth_repository.dart';
import 'package:ta2feela_app/features/auth/data/services/auth_remote_data_source.dart';
import 'package:ta2feela_app/features/auth/data/services/session_local_data_source.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';

void main() {
  test('login response model parses token variants and fallback claims', () {
    const token =
        'header.eyJzdWIiOiJVc3NlZiIsInVzZXJJZCI6ImIyZDA4MTc1LWYwYzAtNGJmMy1iY2NhLTY3MmQ1OTY1ZjdlNCIsInRlbmFudElkIjoiMTcxYzJlYzgtMDljOS00Yzc0LWIxNGMtYWQwYzViZDQ4MDMwIiwicm9sZSI6Ik9XTkVSIiwiZXhwIjoxNzc2NjMwNjMwfQ.signature';

    final model = LoginResponseModel.fromJson({
      'token': token,
      'username': 'Ussef',
      'role': 'OWNER',
    });

    expect(model.accessToken, token);
    expect(model.username, 'Ussef');
    expect(model.backendRole, 'OWNER');
    expect(model.userId, 'b2d08175-f0c0-4bf3-bcca-672d5965f7e4');
    expect(model.role, UserRole.owner);
    expect(model.tenantId, '171c2ec8-09c9-4c74-b14c-ad0c5bd48030');
    expect(model.displayName, 'Ussef');
    expect(model.tokenExpiresAt, isNotNull);
  });

  test('role parser supports confirmed backend roles only', () {
    expect(Session.fromBackendRole('OWNER'), UserRole.owner);
    expect(Session.fromBackendRole('USER'), UserRole.user);
    expect(Session.fromBackendRole('ROLE_USER'), UserRole.unknown);
    expect(Session.fromBackendRole('SYSTEM_ADMIN'), UserRole.unknown);
    expect(Session.fromBackendRole('not-a-supported-role'), UserRole.unknown);
  });

  test('login response model reads list-based role claims', () {
    const token =
        'header.eyJzdWIiOiJ1c2VyMSIsInJvbGVzIjpbIlVTRVIiXX0.signature';

    final model = LoginResponseModel.fromJson({'token': token});

    expect(model.username, 'user1');
    expect(model.backendRole, 'USER');
    expect(model.role, UserRole.user);
  });

  test(
    'repository persists session on successful remote login and clears on logout',
    () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();
      final secureStorage = _FakeSecureStorage();
      final localDataSource = SessionLocalDataSource(
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
      );
      final repository = AppAuthRepository(
        sessionLocalDataSource: localDataSource,
        remoteDataSource: _FakeAuthRemoteDataSource.success(
          LoginResponseModel.fromJson({
            'token':
                'header.eyJzdWIiOiJvd25lcjEiLCJ1c2VySWQiOiJ1c2VyLTEiLCJ0ZW5hbnRJZCI6InRlbmFudC1kZW1vIiwicm9sZSI6Ik9XTkVSIiwiZXhwIjoyNTI0NjA4MDAwfQ.signature',
            'username': 'owner1',
            'role': 'OWNER',
          }),
        ),
      );

      final session = await repository.login(
        username: 'owner1',
        password: 'secret123',
      );

      expect(session.userId, 'user-1');
      expect(session.username, 'owner1');
      expect(session.backendRole, 'OWNER');
      expect(await localDataSource.readAccessToken(), contains('header.'));
      expect(await repository.getCurrentSession(), isNotNull);

      await repository.logout();

      expect(await repository.getCurrentSession(), isNull);
      expect(await localDataSource.readAccessToken(), isNull);
    },
  );

  test('repository preserves unauthorized backend login message', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final repository = AppAuthRepository(
      sessionLocalDataSource: SessionLocalDataSource(
        secureStorage: _FakeSecureStorage(),
        sharedPreferences: sharedPreferences,
      ),
      remoteDataSource: _FakeAuthRemoteDataSource.failure(
        const AppException(
          code: 'UNAUTHORIZED',
          message: 'Unauthorized',
          status: 401,
        ),
      ),
    );

    await expectLater(
      repository.login(username: 'owner1', password: 'bad-password'),
      throwsA(
        isA<AppException>().having(
          (error) => error.message,
          'message',
          'Unauthorized',
        ),
      ),
    );
  });

  test(
    'repository change password forwards only current and new password',
    () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();
      final remoteDataSource = _RecordingAuthRemoteDataSource();
      final repository = AppAuthRepository(
        sessionLocalDataSource: SessionLocalDataSource(
          secureStorage: _FakeSecureStorage(),
          sharedPreferences: sharedPreferences,
        ),
        remoteDataSource: remoteDataSource,
      );

      await repository.changePassword(
        currentPassword: 'old-pass',
        newPassword: 'new-pass-123',
      );

      expect(remoteDataSource.currentPassword, 'old-pass');
      expect(remoteDataSource.newPassword, 'new-pass-123');
    },
  );

  test('repository forgot password returns backend response message', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final remoteDataSource = _RecordingAuthRemoteDataSource();
    remoteDataSource.forgotPasswordMessage =
        'If the account exists, a reset request has been submitted.';
    final repository = AppAuthRepository(
      sessionLocalDataSource: SessionLocalDataSource(
        secureStorage: _FakeSecureStorage(),
        sharedPreferences: sharedPreferences,
      ),
      remoteDataSource: remoteDataSource,
    );

    final result = await repository.forgotPassword(username: 'owner1');

    expect(remoteDataSource.username, 'owner1');
    expect(
      result,
      'If the account exists, a reset request has been submitted.',
    );
  });
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  _FakeAuthRemoteDataSource.success(LoginResponseModel response)
    : _result = ApiSuccess(response);

  _FakeAuthRemoteDataSource.failure(AppException failure)
    : _result = ApiError(failure);

  final ApiResult<LoginResponseModel> _result;

  @override
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    expect(request.toJson()['username'], 'owner1');
    return _result;
  }

  @override
  Future<ApiResult<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  ) async {
    return const ApiSuccess(ForgotPasswordResponseModel());
  }

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    return const ApiSuccess(null);
  }
}

class _RecordingAuthRemoteDataSource implements AuthRemoteDataSource {
  String? currentPassword;
  String? newPassword;
  String? username;
  String? forgotPasswordMessage;

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    this.currentPassword = currentPassword;
    this.newPassword = newPassword;
    return const ApiSuccess(null);
  }

  @override
  Future<ApiResult<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  ) async {
    username = request.username;
    return ApiSuccess(
      ForgotPasswordResponseModel(responseMessage: forgotPasswordMessage),
    );
  }

  @override
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    throw UnimplementedError();
  }
}

class _FakeSecureStorage extends AppSecureStorage {
  _FakeSecureStorage();

  final Map<String, String> _store = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _store.clear();
  }
}
