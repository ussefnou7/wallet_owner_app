import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet_owner_app/core/storage/app_secure_storage.dart';
import 'package:wallet_owner_app/features/auth/data/services/session_local_data_source.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';

void main() {
  const sessionKey = 'auth.session';
  const accessTokenKey = 'auth.access_token';
  const refreshTokenKey = 'auth.refresh_token';

  test('persists and clears session tokens and metadata', () async {
    SharedPreferences.setMockInitialValues({});
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = _FakeSecureStorage();
    final dataSource = SessionLocalDataSource(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    );

    const session = Session(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      username: 'owner@example.com',
      role: UserRole.owner,
      backendRole: 'OWNER',
      tenantId: 'tenant-demo',
      userId: 'owner@example.com',
      displayName: 'Owner User',
    );

    await dataSource.saveSession(session);

    final restoredSession = await dataSource.readSession();

    expect(restoredSession, session);
    expect(await dataSource.readAccessToken(), 'access-token');
    expect(await dataSource.readRefreshToken(), 'refresh-token');

    await dataSource.clearSession();

    expect(await dataSource.readSession(), isNull);
    expect(await dataSource.readAccessToken(), isNull);
    expect(await dataSource.readRefreshToken(), isNull);
  });

  test(
    'restores partial cached session when optional fields are missing',
    () async {
      SharedPreferences.setMockInitialValues({
        sessionKey: '{"username":"Ussef","role":"owner"}',
      });
      final sharedPreferences = await SharedPreferences.getInstance();
      final secureStorage = _FakeSecureStorage()
        ..seed(accessTokenKey, 'access-token');
      final dataSource = SessionLocalDataSource(
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
      );

      final restoredSession = await dataSource.readSession();

      expect(restoredSession, isNotNull);
      expect(restoredSession!.accessToken, 'access-token');
      expect(restoredSession.refreshToken, '');
      expect(restoredSession.username, 'Ussef');
      expect(restoredSession.role, UserRole.owner);
      expect(restoredSession.backendRole, 'owner');
      expect(restoredSession.tenantId, '');
      expect(restoredSession.userId, '');
      expect(restoredSession.displayName, 'Ussef');
    },
  );

  test('clears malformed cached session JSON and returns null', () async {
    SharedPreferences.setMockInitialValues({sessionKey: '{invalid-json'});
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = _FakeSecureStorage()
      ..seed(accessTokenKey, 'access-token')
      ..seed(refreshTokenKey, 'refresh-token');
    final dataSource = SessionLocalDataSource(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    );

    final restoredSession = await dataSource.readSession();

    expect(restoredSession, isNull);
    expect(sharedPreferences.getString(sessionKey), isNull);
    expect(await dataSource.readAccessToken(), isNull);
    expect(await dataSource.readRefreshToken(), isNull);
  });

  test('missing access token is treated as invalid cached session', () async {
    SharedPreferences.setMockInitialValues({
      sessionKey: '{"username":"Ussef","role":"owner"}',
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = _FakeSecureStorage()
      ..seed(refreshTokenKey, 'refresh-token');
    final dataSource = SessionLocalDataSource(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    );

    final restoredSession = await dataSource.readSession();

    expect(restoredSession, isNull);
    expect(sharedPreferences.getString(sessionKey), isNull);
    expect(await dataSource.readAccessToken(), isNull);
    expect(await dataSource.readRefreshToken(), isNull);
  });

  test('expired cached session is cleared and returns null', () async {
    SharedPreferences.setMockInitialValues({
      sessionKey:
          '{"username":"Ussef","role":"OWNER","tokenExpiresAt":"2020-01-01T00:00:00.000Z"}',
    });
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = _FakeSecureStorage()
      ..seed(accessTokenKey, 'access-token')
      ..seed(refreshTokenKey, 'refresh-token');
    final dataSource = SessionLocalDataSource(
      secureStorage: secureStorage,
      sharedPreferences: sharedPreferences,
    );

    final restoredSession = await dataSource.readSession();

    expect(restoredSession, isNull);
    expect(sharedPreferences.getString(sessionKey), isNull);
    expect(await dataSource.readAccessToken(), isNull);
    expect(await dataSource.readRefreshToken(), isNull);
  });

  test('session parser rejects missing token payload', () {
    expect(
      () => Session.fromJson(const {'username': 'Ussef', 'role': 'owner'}),
      throwsA(isA<FormatException>()),
    );
  });
}

class _FakeSecureStorage extends AppSecureStorage {
  _FakeSecureStorage();

  final Map<String, String> _store = {};

  @override
  Future<void> write({required String key, required String value}) async {
    _store[key] = value;
  }

  void seed(String key, String value) {
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
