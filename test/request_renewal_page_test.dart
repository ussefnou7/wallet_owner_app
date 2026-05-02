import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_item.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_payload.dart';
import 'package:ta2feela_app/features/settings/domain/entities/renewal_request_result.dart';
import 'package:ta2feela_app/features/settings/domain/repositories/renewal_requests_repository.dart';
import 'package:ta2feela_app/features/settings/presentation/pages/create_renewal_request_page.dart';
import 'package:ta2feela_app/features/settings/presentation/pages/request_renewal_page.dart';

void main() {
  testWidgets('list page shows empty state and new request button', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          renewalRequestsRepositoryProvider.overrideWithValue(
            _FakeRenewalRequestsRepository(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: RequestRenewalPage())),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.byKey(const Key('renewal_new_request_button')), findsOneWidget);
    expect(find.text('There are no renewal requests yet.'), findsOneWidget);
  });

  testWidgets('create page submits a renewal request', (tester) async {
    final fakeRenewalRepository = _FakeRenewalRequestsRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          renewalRequestsRepositoryProvider.overrideWithValue(
            fakeRenewalRepository,
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(body: CreateRenewalRequestPage()),
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('renewal_phone_field')),
      '01012345678',
    );
    await tester.enterText(
      find.byKey(const Key('renewal_amount_field')),
      '500',
    );
    await tester.enterText(find.byKey(const Key('renewal_period_field')), '3');

    final submitButton = find.byKey(const Key('renewal_submit_button'));
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(fakeRenewalRepository.lastPayload, isNotNull);
    expect(fakeRenewalRepository.lastPayload!.phoneNumber, '01012345678');
    expect(fakeRenewalRepository.lastPayload!.amount, 500);
    expect(fakeRenewalRepository.lastPayload!.periodMonths, 3);
  });
}

class _FakeRenewalRequestsRepository implements RenewalRequestsRepository {
  RenewalRequestPayload? lastPayload;

  @override
  Future<RenewalRequestResult> submitRequest(RenewalRequest request) async {
    return const RenewalRequestResult(
      requestId: 'RR-TEST-001',
      targetPlanName: 'Enterprise',
    );
  }

  @override
  Future<List<RenewalRequestItem>> getMyRenewalRequests() async => const [];

  @override
  Future<void> createRenewalRequest(RenewalRequestPayload payload) async {
    lastPayload = payload;
  }
}
