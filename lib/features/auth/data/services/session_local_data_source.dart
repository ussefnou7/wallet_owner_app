import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/app_secure_storage.dart';
import '../../domain/entities/session.dart';

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
    await Future.wait([
      _secureStorage.write(key: _accessTokenKey, value: session.accessToken),
      _secureStorage.write(key: _refreshTokenKey, value: session.refreshToken),
    ]);
    await _sharedPreferences.setString(
      _sessionKey,
      jsonEncode(session.toJson()),
    );
  }

  Future<Session?> readSession() async {
    final storedSession = _sharedPreferences.getString(_sessionKey);
    final accessToken = await _secureStorage.read(_accessTokenKey);
    final refreshToken = await _secureStorage.read(_refreshTokenKey);

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
    await Future.wait([
      _secureStorage.delete(_accessTokenKey),
      _secureStorage.delete(_refreshTokenKey),
    ]);
    await _sharedPreferences.remove(_sessionKey);
  }
}
