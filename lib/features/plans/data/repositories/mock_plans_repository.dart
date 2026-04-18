import '../../domain/entities/plan.dart';
import '../../domain/entities/subscription_summary.dart';
import '../../domain/repositories/plans_repository.dart';
import '../models/plan_model.dart';
import '../models/subscription_catalog_model.dart';
import '../models/subscription_summary_model.dart';

class MockPlansRepository implements PlansRepository {
  @override
  Future<SubscriptionCatalogModel> getSubscriptionCatalog() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return SubscriptionCatalogModel(
      currentSubscription: SubscriptionSummaryModel(
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
          description:
              'For smaller owner teams managing a focused wallet operation.',
          maxUsers: 8,
          maxWallets: 12,
          maxBranches: 2,
          badge: PlanBadge.available,
        ),
        PlanModel(
          id: 'growth',
          name: 'Growth',
          description:
              'Balanced capacity for growing multi-branch wallet management.',
          maxUsers: 25,
          maxWallets: 40,
          maxBranches: 8,
          badge: PlanBadge.current,
        ),
        PlanModel(
          id: 'enterprise',
          name: 'Enterprise',
          description:
              'Expanded limits and oversight for high-volume owner workspaces.',
          maxUsers: 80,
          maxWallets: 150,
          maxBranches: 24,
          badge: PlanBadge.recommended,
        ),
      ],
    );
  }
}
