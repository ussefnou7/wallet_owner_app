import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ta2feela_app/app/app.dart';
import 'package:ta2feela_app/core/localization/app_locale.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/core/localization/locale_storage.dart';
import 'package:ta2feela_app/core/storage/app_secure_storage.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  group('LocaleStorage', () {
    test(
      'falls back to ar-EG on first launch when no saved preference exists',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = LocaleStorage(prefs);

        expect(storage.readLocale(), arabicEgyptAppLocale);
      },
    );

    test('uses saved en preference when it exists', () async {
      SharedPreferences.setMockInitialValues({
        appLanguageKey: englishLocaleCode,
      });
      final prefs = await SharedPreferences.getInstance();
      final storage = LocaleStorage(prefs);

      expect(storage.readLocale(), englishAppLocale);
    });

    test('uses saved ar-EG preference when it exists', () async {
      SharedPreferences.setMockInitialValues({
        appLanguageKey: arabicEgyptLocaleCode,
      });
      final prefs = await SharedPreferences.getInstance();
      final storage = LocaleStorage(prefs);

      expect(storage.readLocale(), arabicEgyptAppLocale);
    });

    test('falls back to ar-EG for invalid or old saved values', () async {
      SharedPreferences.setMockInitialValues({appLanguageKey: 'fr'});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocaleStorage(prefs);

      expect(storage.readLocale(), arabicEgyptAppLocale);

      await prefs.setString(appLanguageKey, 'ar');
      expect(storage.readLocale(), arabicEgyptAppLocale);
    });

    test('persists only en and ar-EG locale codes', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final storage = LocaleStorage(prefs);

      await storage.saveLocale(englishAppLocale);
      expect(prefs.getString(appLanguageKey), englishLocaleCode);

      await storage.saveLocale(const Locale('ar'));
      expect(prefs.getString(appLanguageKey), arabicEgyptLocaleCode);
    });
  });

  group('LocaleController', () {
    test('defaults to ar-EG when storage is unavailable', () {
      expect(LocaleController(null).state, arabicEgyptAppLocale);
    });

    test(
      'restores English after saving it and recreating the controller',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = LocaleStorage(prefs);
        final controller = LocaleController(storage);

        await controller.setLocale(englishAppLocale);

        expect(controller.state, englishAppLocale);
        expect(LocaleController(storage).state, englishAppLocale);
      },
    );

    test(
      'restores Arabic after saving it and recreating the controller',
      () async {
        SharedPreferences.setMockInitialValues({});
        final prefs = await SharedPreferences.getInstance();
        final storage = LocaleStorage(prefs);
        final controller = LocaleController(storage);

        await controller.setLocale(arabicEgyptAppLocale);

        expect(controller.state, arabicEgyptAppLocale);
        expect(LocaleController(storage).state, arabicEgyptAppLocale);
      },
    );
  });

  testWidgets(
    'first launch stays Arabic even when the device locale is English',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      final binding = TestWidgetsFlutterBinding.ensureInitialized();
      binding.platformDispatcher.localeTestValue = const Locale('en');
      addTearDown(binding.platformDispatcher.clearLocaleTestValue);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            authControllerProvider.overrideWith(
              (ref) => AuthController(
                authRepository: _FakeAuthRepository(),
                initialSession: null,
              ),
            ),
          ],
          child: const App(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('تسجيل الدخول'), findsWidgets);
      expect(find.text('اسم المستخدم'), findsAtLeastNWidgets(1));
      expect(find.text('كلمة المرور'), findsAtLeastNWidgets(1));
    },
  );
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Session?> getCurrentSession() async => null;

  @override
  Future<Session> login({required String username, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<Session> refreshSession({Session? currentSession}) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveSession(Session session) async {}

  @override
  Future<String?> forgotPassword({required String username}) async => null;

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<void> logout() async {}
}
