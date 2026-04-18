import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/app_secure_storage.dart';
import '../../domain/entities/session.dart';

final sessionLocalDataSourceProvider = Provider<SessionLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return SessionLocalDataSource(
    secureStorage: secureStorage,
    sharedPreferences: sharedPreferences,
  );
});

class SessionLocalDataSource {
  SessionLocalDataSource({
    required AppSecureStorage secureStorage,
    required SharedPreferences sharedPreferences,
  }) : _secureStorage = secureStorage,
       _sharedPreferences = sharedPreferences;

  static const _accessTokenKey = 'auth.access_token';
  static const _refreshTokenKey = 'auth.refresh_token';
  static const _sessionKey = 'auth.session';

  final AppSecureStorage _secureStorage;
  final SharedPreferences _sharedPreferences;

  Future<void> saveSession(Session session) async {
    await saveTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
    await _sharedPreferences.setString(
      _sessionKey,
      jsonEncode(session.toJson()),
    );
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    return Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: refreshToken),
    ]);
  }

  Future<String?> readAccessToken() {
    return _secureStorage.read(_accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _secureStorage.read(_refreshTokenKey);
  }

  Future<Session?> readSession() async {
    final storedSession = _sharedPreferences.getString(_sessionKey);
    final accessToken = await readAccessToken();
    final refreshToken = await readRefreshToken();

    if (storedSession == null || accessToken == null || refreshToken == null) {
      return null;
    }

    final decoded = jsonDecode(storedSession) as Map<String, dynamic>;
    return Session.fromJson(
      decoded
        ..addAll({'accessToken': accessToken, 'refreshToken': refreshToken}),
    );
  }

  Future<void> clearSession() async {
    await clearTokens();
    await _sharedPreferences.remove(_sessionKey);
  }

  Future<void> clearTokens() {
    return Future.wait([
      _secureStorage.delete(_accessTokenKey),
      _secureStorage.delete(_refreshTokenKey),
    ]);
  }
}
