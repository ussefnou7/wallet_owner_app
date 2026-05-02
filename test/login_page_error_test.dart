import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/core/errors/app_exception.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ta2feela_app/features/auth/presentation/pages/login_page.dart';
import 'package:ta2feela_app/l10n/generated/app_localizations.dart';

void main() {
  testWidgets('login 401 structured error shows localized inline message', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeControllerProvider.overrideWith((ref) {
            final controller = LocaleController(null);
            controller.setLocale(const Locale('en'));
            return controller;
          }),
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(
                loginError: const AppException(
                  code: 'UNAUTHORIZED',
                  message: 'Invalid username or password',
                  status: 401,
                  traceId: 'trace-login-401',
                ),
              ),
              initialSession: null,
            ),
          ),
        ],
        child: const MaterialApp(
          locale: Locale('en'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: LoginPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), 'owner1');
    await tester.enterText(find.byType(TextFormField).at(1), 'bad-password');
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byKey(const Key('login_inline_error')), findsOneWidget);
    expect(find.text('Invalid username or password'), findsOneWidget);
    expect(find.text('Unable to sign in. Please try again.'), findsNothing);
  });
}

class _FakeAuthRepository implements AuthRepository {
  _FakeAuthRepository({this.loginError});

  final AppException? loginError;

  @override
  Future<Session?> getCurrentSession() async => null;

  @override
  Future<Session> login({
    required String username,
    required String password,
  }) async {
    if (loginError != null) {
      throw loginError!;
    }

    throw UnimplementedError();
  }

  @override
  Future<String?> forgotPassword({required String username}) async {
    return null;
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {}

  @override
  Future<void> logout() async {}
}
