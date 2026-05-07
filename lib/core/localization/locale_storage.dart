import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../storage/app_secure_storage.dart';
import 'app_locale.dart';

const appLanguageKey = 'app_language';

final localeStorageProvider = Provider<LocaleStorage>((ref) {
  final sharedPreferences = ref.watch(sharedPreferencesProvider);
  return LocaleStorage(sharedPreferences);
});

class LocaleStorage {
  const LocaleStorage(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Locale readLocale() {
    return parseStoredAppLocale(_sharedPreferences.getString(appLanguageKey));
  }

  Future<void> saveLocale(Locale locale) {
    return _sharedPreferences.setString(
      appLanguageKey,
      toStoredAppLocaleCode(locale),
    );
  }
}
