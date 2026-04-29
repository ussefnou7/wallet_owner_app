import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/features/settings/domain/entities/support_ticket.dart';
import 'package:wallet_owner_app/features/settings/domain/entities/support_ticket_item.dart';
import 'package:wallet_owner_app/features/settings/domain/repositories/support_repository.dart';
import 'package:wallet_owner_app/features/settings/presentation/pages/create_support_ticket_page.dart';
import 'package:wallet_owner_app/features/settings/presentation/pages/support_page.dart';

void main() {
  testWidgets('list page shows empty state and new ticket button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportRepositoryProvider.overrideWithValue(_FakeSupportRepository()),
        ],
        child: const MaterialApp(home: Scaffold(body: SupportPage())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('support_new_ticket_button')), findsOneWidget);
    expect(find.text('There are no support tickets yet.'), findsOneWidget);
  });

  testWidgets('create page submits subject description and priority', (
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

    final priorityField = find.byKey(const Key('support_priority_field'));
    await tester.ensureVisible(priorityField);
    await tester.tap(priorityField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('High').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('support_submit_button')));
    await tester.pumpAndSettle();

    expect(fakeSupportRepository.lastTicket, isNotNull);
    expect(fakeSupportRepository.lastTicket!.subject, 'Printer issue');
    expect(
      fakeSupportRepository.lastTicket!.description,
      'The receipt printer stops after the first line.',
    );
    expect(fakeSupportRepository.lastTicket!.priority, SupportPriority.high);
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
