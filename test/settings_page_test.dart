import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/app/app.dart';
import 'package:wallet_owner_app/core/localization/locale_controller.dart';
import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';

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
        ],
        child: const App(),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.menu_rounded).first);
    await tester.pumpAndSettle();
    final settingsNavItem = find.byKey(const Key('settings_nav_item'));
    final drawerScrollable = find.descendant(
      of: find.byType(Drawer).last,
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      settingsNavItem,
      200,
      scrollable: drawerScrollable,
    );
    await tester.tap(settingsNavItem.first);
    await tester.pumpAndSettle();

    expect(find.text('Owner Settings'), findsOneWidget);
    expect(find.text('Owner User'), findsOneWidget);
    expect(find.text('Workspace: BTC Workspace'), findsNothing);
    expect(find.text('Account'), findsNothing);

    final pageScrollable = find.descendant(
      of: find.byType(SingleChildScrollView),
      matching: find.byType(Scrollable),
    );
    final logoutButton = find.byKey(const Key('logout_button'));
    await tester.ensureVisible(logoutButton.first);
    await tester.drag(pageScrollable, const Offset(0, -200));
    await tester.pumpAndSettle();
    final logoutTapPoint =
        tester.getTopLeft(logoutButton.first) + const Offset(24, 24);
    await tester.tapAt(logoutTapPoint);
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
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {}

  @override
  Future<void> logout() async {}
}
