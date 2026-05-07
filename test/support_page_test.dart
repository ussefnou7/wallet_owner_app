import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:ta2feela_app/app/router/app_routes.dart';
import 'package:ta2feela_app/features/auth/domain/entities/session.dart';
import 'package:ta2feela_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:ta2feela_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:ta2feela_app/features/settings/domain/entities/support_ticket.dart';
import 'package:ta2feela_app/features/settings/domain/entities/support_ticket_item.dart';
import 'package:ta2feela_app/features/settings/domain/repositories/support_repository.dart';
import 'package:ta2feela_app/features/settings/presentation/pages/create_support_ticket_page.dart';
import 'package:ta2feela_app/features/settings/presentation/pages/support_page.dart';

void main() {
  testWidgets('list page shows empty state and new ticket button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: _userSession,
            ),
          ),
          supportRepositoryProvider.overrideWithValue(_FakeSupportRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: SupportPage())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('support_new_ticket_button')), findsOneWidget);
    expect(find.text('There are no support tickets yet.'), findsOneWidget);
  });

  testWidgets('create page submits subject and message with default priority', (
    tester,
  ) async {
    final fakeSupportRepository = _FakeSupportRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportRepositoryProvider.overrideWithValue(fakeSupportRepository),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CreateSupportTicketPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('support_subject_field')),
      'Printer issue',
    );
    await tester.enterText(
      find.byKey(const Key('support_description_field')),
      'The receipt printer stops after the first line.',
    );

    await tester.tap(find.byKey(const Key('support_submit_button')));
    await tester.pumpAndSettle();

    expect(fakeSupportRepository.lastTicket, isNotNull);
    expect(fakeSupportRepository.lastTicket!.subject, 'Printer issue');
    expect(
      fakeSupportRepository.lastTicket!.description,
      'The receipt printer stops after the first line.',
    );
    expect(fakeSupportRepository.lastTicket!.priority, SupportPriority.medium);
  });

  testWidgets('user support page opens user create ticket route', (
    tester,
  ) async {
    final router = GoRouter(
      initialLocation: AppRoutes.userSupport,
      routes: [
        GoRoute(
          path: AppRoutes.userSupport,
          builder: (context, state) => const Scaffold(body: SupportPage()),
        ),
        GoRoute(
          path: AppRoutes.userCreateSupport,
          builder: (context, state) =>
              const Scaffold(body: CreateSupportTicketPage()),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authControllerProvider.overrideWith(
            (ref) => AuthController(
              authRepository: _FakeAuthRepository(),
              initialSession: _userSession,
            ),
          ),
          supportRepositoryProvider.overrideWithValue(_FakeSupportRepository()),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Support Tickets'), findsNWidgets(2));
    await tester.tap(find.byKey(const Key('support_new_ticket_button')));
    await tester.pumpAndSettle();

    expect(find.byType(CreateSupportTicketPage), findsOneWidget);
  });
}

class _FakeSupportRepository implements SupportRepository {
  SupportTicket? lastTicket;

  @override
  Future<List<SupportTicketItem>> getMyTickets() async => const [];

  @override
  Future<void> createTicket(SupportTicket ticket) async {
    lastTicket = ticket;
  }
}

const _userSession = Session(
  accessToken: 'token',
  refreshToken: 'refresh',
  username: 'user@example.com',
  role: UserRole.user,
  backendRole: 'USER',
  tenantId: 'tenant-demo',
  userId: 'user-1',
  displayName: 'Normal User',
);

class _FakeAuthRepository implements AuthRepository {
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
  Future<void> logout() async {}
}
