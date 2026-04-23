import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    : super(_storage?.readLocale() ?? const Locale('ar'));

  final LocaleStorage? _storage;

  Future<void> setLocale(Locale locale) async {
    if (!_isSupported(locale)) {
      return;
    }

    state = Locale(locale.languageCode);
    await _storage?.saveLocale(state);
  }

  Future<void> toggleLocale() {
    return setLocale(Locale(state.languageCode == 'ar' ? 'en' : 'ar'));
  }

  bool _isSupported(Locale locale) {
    return locale.languageCode == 'en' || locale.languageCode == 'ar';
  }
}
