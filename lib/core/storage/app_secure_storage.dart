import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorageProvider = Provider<AppSecureStorage>((ref) {
  return const AppSecureStorage();
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden at bootstrap',
  );
});

class AppSecureStorage {
  const AppSecureStorage();

  static const _storage = FlutterSecureStorage();

  Future<void> write({required String key, required String value}) {
    return _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) {
    return _storage.read(key: key);
  }

  Future<void> delete(String key) {
    return _storage.delete(key: key);
  }
}
