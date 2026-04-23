import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet_owner_app/core/errors/app_failure.dart';
import 'package:wallet_owner_app/core/network/api_result.dart';
import 'package:wallet_owner_app/core/storage/app_secure_storage.dart';
import 'package:wallet_owner_app/features/auth/data/models/login_request_model.dart';
import 'package:wallet_owner_app/features/auth/data/models/login_response_model.dart';
import 'package:wallet_owner_app/features/auth/data/repositories/app_auth_repository.dart';
import 'package:wallet_owner_app/features/auth/data/services/auth_remote_data_source.dart';
import 'package:wallet_owner_app/features/auth/data/services/session_local_data_source.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';

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
                'header.eyJzdWIiOiJvd25lcjEiLCJ1c2VySWQiOiJ1c2VyLTEiLCJ0ZW5hbnRJZCI6InRlbmFudC1kZW1vIiwicm9sZSI6Ik9XTkVSIn0.signature',
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

  test(
    'repository maps unauthorized login failures to a user-friendly message',
    () async {
      SharedPreferences.setMockInitialValues({});
      final sharedPreferences = await SharedPreferences.getInstance();
      final repository = AppAuthRepository(
        sessionLocalDataSource: SessionLocalDataSource(
          secureStorage: _FakeSecureStorage(),
          sharedPreferences: sharedPreferences,
        ),
        remoteDataSource: _FakeAuthRemoteDataSource.failure(
          const UnauthorizedFailure('Unauthorized', statusCode: 401),
        ),
      );

      await expectLater(
        repository.login(username: 'owner1', password: 'bad-password'),
        throwsA(
          isA<AppFailureException>().having(
            (error) => error.failure.message,
            'message',
            'Invalid username or password.',
          ),
        ),
      );
    },
  );
}

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  _FakeAuthRemoteDataSource.success(LoginResponseModel response)
    : _result = ApiSuccess(response);

  _FakeAuthRemoteDataSource.failure(AppFailure failure)
    : _result = ApiError(failure);

  final ApiResult<LoginResponseModel> _result;

  @override
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    expect(request.toJson()['username'], 'owner1');
    return _result;
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
