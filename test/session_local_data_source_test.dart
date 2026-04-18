import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:wallet_owner_app/core/storage/app_secure_storage.dart';
import 'package:wallet_owner_app/features/auth/data/services/session_local_data_source.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';

void main() {
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
      role: UserRole.owner,
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
