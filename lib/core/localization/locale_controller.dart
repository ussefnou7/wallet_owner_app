import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_locale.dart';
import 'locale_storage.dart';

final localeControllerProvider =
    StateNotifierProvider<LocaleController, Locale>((ref) {
      LocaleStorage? storage;
      try {
        storage = ref.watch(localeStorageProvider);
      } catch (_) {
        storage = null;
      }
      return LocaleController(storage);
    });

class LocaleController extends StateNotifier<Locale> {
  LocaleController(this._storage)
    : super(_storage?.readLocale() ?? arabicEgyptAppLocale);

  final LocaleStorage? _storage;

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale)) {
      return;
    }

    state = normalizeAppLocale(locale);
    await _storage?.saveLocale(state);
  }

  Future<void> toggleLocale() {
    return setLocale(
      state.languageCode == 'ar' ? englishAppLocale : arabicEgyptAppLocale,
    );
  }

  bool _isSupported(Locale locale) {
    return isSupportedAppLocale(locale);
  }
}
