import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/app/app.dart';
import 'package:wallet_owner_app/core/localization/locale_controller.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:wallet_owner_app/features/plans/data/repositories/mock_plans_repository.dart';
import 'package:wallet_owner_app/features/plans/domain/repositories/plans_repository.dart';

void main() {
  testWidgets('logout from settings returns to login flow', (tester) async {
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
              initialSession: const Session(
                accessToken: 'token',
                refreshToken: 'refresh',
                username: 'owner@example.com',
                role: UserRole.owner,
                backendRole: 'OWNER',
                tenantId: 'tenant-demo',
                userId: 'owner@example.com',
                displayName: 'Owner User',
              ),
            ),
          ),
          plansRepositoryProvider.overrideWithValue(MockPlansRepository()),
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('Owner Settings'), findsOneWidget);
    expect(find.text('Owner User'), findsWidgets);
    expect(find.text('owner@example.com'), findsWidgets);

    await tester.scrollUntilVisible(find.text('Logout'), 200);
    await tester.tap(find.text('Logout'));
    await tester.pumpAndSettle();

    expect(find.text('Sign in'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
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
