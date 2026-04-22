import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wallet_owner_app/features/auth/domain/entities/session.dart';
import 'package:wallet_owner_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:wallet_owner_app/features/auth/presentation/controllers/auth_controller.dart';
import 'package:wallet_owner_app/features/plans/data/models/plan_model.dart';
import 'package:wallet_owner_app/features/plans/domain/entities/subscription_catalog.dart';
import 'package:wallet_owner_app/features/plans/domain/entities/subscription_summary.dart';
import 'package:wallet_owner_app/features/plans/domain/repositories/plans_repository.dart';
import 'package:wallet_owner_app/features/settings/domain/entities/renewal_request.dart';
import 'package:wallet_owner_app/features/settings/domain/entities/renewal_request_result.dart';
import 'package:wallet_owner_app/features/settings/domain/repositories/renewal_requests_repository.dart';
import 'package:wallet_owner_app/features/settings/presentation/pages/request_renewal_page.dart';

void main() {
  testWidgets('validates and submits a renewal request', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
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
          plansRepositoryProvider.overrideWithValue(_FakePlansRepository()),
          renewalRequestsRepositoryProvider.overrideWithValue(
            _FakeRenewalRequestsRepository(),
          ),
        ],
        child: const MaterialApp(home: RequestRenewalPage()),
      ),
    );

    await tester.pumpAndSettle();

    final submitButton = find.text('Submit Renewal Request');
    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pumpAndSettle();

    expect(find.text('Please select a target plan'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enterprise').last);
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Note'),
      'Need higher branch capacity for next quarter.',
    );

    await tester.ensureVisible(submitButton);
    await tester.tap(submitButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));

    expect(
      find.textContaining('Renewal request submitted for Enterprise'),
      findsWidgets,
    );
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

class _FakePlansRepository implements PlansRepository {
  @override
  Future<SubscriptionCatalog> getSubscriptionCatalog() async {
    return SubscriptionCatalog(
      currentSubscription: SubscriptionSummary(
        planId: 'growth',
        planName: 'Growth',
        status: SubscriptionStatus.active,
        renewalDate: DateTime(2026, 5, 12),
        maxUsers: 25,
        maxWallets: 40,
        maxBranches: 8,
        activeUsers: 18,
        activeWallets: 26,
        activeBranches: 5,
      ),
      plans: const [
        PlanModel(
          id: 'starter',
          name: 'Starter',
          description: 'Starter tier',
          maxUsers: 8,
          maxWallets: 12,
          maxBranches: 2,
        ),
        PlanModel(
          id: 'enterprise',
          name: 'Enterprise',
          description: 'Enterprise tier',
          maxUsers: 80,
          maxWallets: 150,
          maxBranches: 24,
        ),
      ],
    );
  }
}

class _FakeRenewalRequestsRepository implements RenewalRequestsRepository {
  @override
  Future<RenewalRequestResult> submitRequest(RenewalRequest request) async {
    return const RenewalRequestResult(
      requestId: 'RR-TEST-001',
      targetPlanName: 'Enterprise',
    );
  }
}
