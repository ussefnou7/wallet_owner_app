import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ta2feela_app/app/app.dart';
import 'package:ta2feela_app/core/localization/locale_controller.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ta2feela_app/features/notifications/domain/entities/notification_count.dart';
import 'package:ta2feela_app/features/notifications/domain/entities/notification_unread_grouped.dart';
import 'package:ta2feela_app/features/notifications/domain/repositories/notifications_repository.dart';
import 'package:ta2feela_app/features/settings/presentation/pages/terms_and_conditions_page.dart';

void main() {
  testWidgets('settings legal links open production legal pages', (
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

    final pageScrollable = find.descendant(
      of: find.byType(SingleChildScrollView).first,
      matching: find.byType(Scrollable),
    );

    await tester.scrollUntilVisible(
      find.byKey(const Key('about_page_tile')),
      200,
      scrollable: pageScrollable,
    );
    await tester.tap(find.byKey(const Key('about_page_tile')));
    await tester.pumpAndSettle();
    expect(find.textContaining('wallet management app'), findsOneWidget);
    expect(find.textContaining('Current app version: 1.0.0'), findsOneWidget);
    expect(find.byType(BackButtonIcon), findsOneWidget);

    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2));

    await tester.scrollUntilVisible(
      find.byKey(const Key('privacy_policy_page_tile')),
      200,
      scrollable: pageScrollable,
    );
    await tester.tap(find.byKey(const Key('privacy_policy_page_tile')));
    await tester.pumpAndSettle();
    expect(find.textContaining('username, role, wallet data'), findsOneWidget);
    await tester.tap(find.byType(BackButtonIcon));
    await tester.pumpAndSettle();
    expect(find.text('Settings'), findsNWidgets(2));

    await tester.scrollUntilVisible(
      find.byKey(const Key('terms_and_conditions_page_tile')),
      200,
      scrollable: pageScrollable,
    );
    await tester.tap(find.byKey(const Key('terms_and_conditions_page_tile')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('keep your account credentials secure'),
      findsOneWidget,
    );
    expect(find.byType(TermsAndConditionsPage), findsOneWidget);
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
