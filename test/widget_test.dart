import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/app/app.dart';
import 'package:wallet_owner_app/core/localization/locale_controller.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';

void main() {
  testWidgets('renders login page when unauthenticated', (tester) async {
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
              authRepository: _FakeAuthRepository(),
              initialSession: null,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
  });

  testWidgets('shows validation messages for empty login form', (tester) async {
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
              authRepository: _FakeAuthRepository(),
              initialSession: null,
            ),
          ),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(0), '');
    await tester.enterText(find.byType(TextFormField).at(1), '');
    final loginButton = find.text('Login');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    expect(find.text('Username is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<Session?> getCurrentSession() async => null;

  @override
  Future<Session> login({required String username, required String password}) {
    throw UnimplementedError();
  }

  @override
  Future<void> logout() async {}
}
