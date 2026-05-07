import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ta2feela_app/app/app.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';

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

  testWidgets(
    'forgot password form validates and displays backend response message',
    (tester) async {
      final authRepository = _RecordingAuthRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            localeControllerProvider.overrideWith((ref) {
              final controller = LocaleController(null);
              controller.setLocale(const Locale('en'));
              return controller;
            }),
            authRepositoryProvider.overrideWithValue(authRepository),
            authControllerProvider.overrideWith(
              (ref) => AuthController(
                authRepository: authRepository,
                initialSession: null,
              ),
            ),
          ],
          child: const App(),
        ),
      );

      await tester.pumpAndSettle();

      await tester.tap(find.text('Forgot password?'));
      await tester.pumpAndSettle();

      expect(find.text('Reset password'), findsOneWidget);
      await tester.tap(find.text('Submit request'));
      await tester.pumpAndSettle();

      expect(find.text('Username is required'), findsOneWidget);
      expect(authRepository.forgotPasswordCalls, 0);

      await tester.enterText(
        find.byType(TextFormField).first,
        'owner@example.com',
      );
      await tester.tap(find.text('Submit request'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(authRepository.forgotPasswordCalls, 1);
      expect(authRepository.username, 'owner@example.com');
      expect(
        find.text('Reset request submitted from backend.'),
        findsOneWidget,
      );
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
  Future<Session> refreshSession({Session? currentSession}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> saveSession(Session session) async {}

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

class _RecordingAuthRepository extends _FakeAuthRepository {
  int forgotPasswordCalls = 0;
  String? username;

  @override
  Future<String?> forgotPassword({required String username}) async {
    forgotPasswordCalls += 1;
    this.username = username;
    return 'Reset request submitted from backend.';
  }
}
