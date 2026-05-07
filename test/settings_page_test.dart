import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ta2feela_app/app/app.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ta2feela_app/features/auth/presentation/pages/login_page.dart';
import 'package:ta2feela_app/features/notifications/domain/entities/notification_count.dart';
import 'package:ta2feela_app/features/notifications/domain/entities/notification_unread_grouped.dart';
import 'package:ta2feela_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_item.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_payload.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_result.dart';
import 'package:ta2feela_app/features/settings/domain/repositories/renewal_requests_repository.dart';

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
          notificationsRepositoryProvider.overrideWithValue(
            _FakeNotificationsRepository(),
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

    expect(find.text('Settings'), findsNWidgets(2));
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

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets('settings detail screens show back affordance to settings', (
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
          notificationsRepositoryProvider.overrideWithValue(
            _FakeNotificationsRepository(),
          ),
          renewalRequestsRepositoryProvider.overrideWithValue(
            _FakeRenewalRequestsRepository(),
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

    final browsePlansTile = find.byKey(const Key('browse_plans_tile'));
    await tester.ensureVisible(browsePlansTile);
    await tester.tap(browsePlansTile);
    await tester.pumpAndSettle();
    expect(find.byType(BackButtonIcon), findsOneWidget);
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2));

    final requestRenewalTile = find.byKey(const Key('request_renewal_tile'));
    await tester.ensureVisible(requestRenewalTile);
    await tester.tap(requestRenewalTile);
    await tester.pumpAndSettle();
    expect(find.byType(BackButtonIcon), findsOneWidget);
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2));

    final changePasswordTile = find.byKey(const Key('change_password_tile'));
    await tester.ensureVisible(changePasswordTile);
    await tester.tap(changePasswordTile);
    await tester.pumpAndSettle();
    expect(find.byType(BackButtonIcon), findsOneWidget);
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2));
  });

  testWidgets(
    'change password validates locally and submits only current and new password',
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
            notificationsRepositoryProvider.overrideWithValue(
              _FakeNotificationsRepository(),
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

      final changePasswordTile = find.byKey(const Key('change_password_tile'));
      await tester.ensureVisible(changePasswordTile);
      await tester.tap(changePasswordTile);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Current password is required'), findsOneWidget);
      expect(find.text('New password is required'), findsOneWidget);
      expect(find.text('Please confirm the new password'), findsOneWidget);
      expect(authRepository.changePasswordCalls, 0);

      await tester.enterText(find.byType(TextFormField).at(0), 'old-pass');
      await tester.enterText(find.byType(TextFormField).at(1), 'new-pass-123');
      await tester.enterText(find.byType(TextFormField).at(2), 'mismatch');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Passwords do not match'), findsOneWidget);
      expect(authRepository.changePasswordCalls, 0);

      await tester.enterText(find.byType(TextFormField).at(2), 'new-pass-123');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(authRepository.changePasswordCalls, 1);
      expect(authRepository.currentPassword, 'old-pass');
      expect(authRepository.newPassword, 'new-pass-123');
      expect(find.text('Password changed successfully.'), findsOneWidget);
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
  int changePasswordCalls = 0;
  int forgotPasswordCalls = 0;
  String? currentPassword;
  String? newPassword;
  String? username;

  @override
  Future<String?> forgotPassword({required String username}) async {
    forgotPasswordCalls += 1;
    this.username = username;
    return 'Reset request submitted from backend.';
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    changePasswordCalls += 1;
    this.currentPassword = currentPassword;
    this.newPassword = newPassword;
  }
}

class _FakeNotificationsRepository implements NotificationsRepository {
  @override
  Future<NotificationUnreadGrouped> getUnreadNotifications({
    int limit = 20,
  }) async {
    return const NotificationUnreadGrouped(
      unreadCount: 0,
      important: [],
      low: [],
    );
  }

  @override
  Future<NotificationCount> getUnreadCount() async {
    return const NotificationCount(count: 0);
  }

  @override
  Future<void> markAllAsRead() async {}

  @override
  Future<void> markLowAsRead() async {}

  @override
  Future<void> markOneAsRead(String notificationId) async {}
}

class _FakeRenewalRequestsRepository implements RenewalRequestsRepository {
  @override
  Future<void> createRenewalRequest(RenewalRequestPayload payload) async {}

  @override
  Future<List<RenewalRequestItem>> getMyRenewalRequests() async => const [];

  @override
  Future<RenewalRequestResult> submitRequest(RenewalRequest request) async {
    return const RenewalRequestResult(
      requestId: 'RR-TEST-001',
      targetPlanName: 'Enterprise',
    );
  }
}
