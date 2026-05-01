import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/storage/app_secure_storage.dart';
import '../../domain/entities/session.dart';
import 'jwt_decoder.dart';

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
    if (storedSession == null || storedSession.isEmpty) {
      await _clearDanglingSessionArtifacts();
      return null;
    }

    try {
      final accessToken = await readAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        await clearSession();
        return null;
      }

      final tokenExpiresAt = JwtDecoder.tryReadExpiration(accessToken);
      if (tokenExpiresAt == null ||
          JwtDecoder.isExpiredOrInvalid(accessToken)) {
        await clearSession();
        return null;
      }

      final refreshToken = await readRefreshToken();
      final decoded = jsonDecode(storedSession);
      if (decoded is! Map) {
        await clearSession();
        return null;
      }

      final storedSessionMap = Map<String, dynamic>.from(decoded);

      final session = Session.fromJson({
        ...storedSessionMap,
        'accessToken': accessToken,
        'refreshToken':
            refreshToken ?? (storedSessionMap['refreshToken'] as String?),
        'tokenExpiresAt': tokenExpiresAt.toIso8601String(),
      });

      return session;
    } catch (_) {
      await clearSession();
      return null;
    }
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

  Future<void> _clearDanglingSessionArtifacts() async {
    final accessToken = await readAccessToken();
    final refreshToken = await readRefreshToken();
    if ((accessToken != null && accessToken.isNotEmpty) ||
        (refreshToken != null && refreshToken.isNotEmpty)) {
      await clearSession();
    }
  }
}
