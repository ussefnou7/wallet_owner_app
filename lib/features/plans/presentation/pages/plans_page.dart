import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
import '../../../../core/widgets/subscription_summary_card.dart';
import '../../domain/entities/plan.dart';
import '../controllers/plans_controller.dart';
import '../widgets/plan_card.dart';

class PlansPage extends ConsumerWidget {
  const PlansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansState = ref.watch(plansControllerProvider);
    final l10n = appL10n(context);

    return AppPageScaffold(
      title: l10n.plans,
      actions: [
        IconButton(
          onPressed: () => ref.read(plansControllerProvider.notifier).reload(),
          icon: const Icon(Icons.refresh_rounded),
        ),
        Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => Scaffold.of(context).openEndDrawer(),
              icon: const Icon(Icons.menu_rounded),
            );
          },
        ),
      ],
      endDrawer: const OwnerAppDrawer(currentRoute: AppRoutes.plans),
      bottomNavigationBar: AppBottomNavBar(
        currentRoute: '',
        onDestinationSelected: context.go,
      ),
      maxWidth: AppDimensions.contentMaxWidth,
      child: plansState.when(
        loading: () => AppLoadingView(message: l10n.loadingSubscriptionPlans),
        error: (error, stackTrace) => AppErrorState(
          message: l10n.unableToLoadSubscriptionDetails,
          onRetry: () => ref.read(plansControllerProvider.notifier).reload(),
        ),
        data: (catalog) {
          if (catalog.plans.isEmpty) {
            return AppEmptyState(
              title: l10n.noPlansAvailable,
              message: l10n.plansEmptyMessage,
              icon: Icons.workspace_premium_outlined,
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSectionHeader(
                  title: l10n.subscriptionPlans,
                  subtitle: l10n.subscriptionPlansSubtitle,
                ),
                const SizedBox(height: AppSpacing.md),
                SubscriptionSummaryCard(
                  summary: catalog.currentSubscription,
                  subtitle: l10n.subscriptionSummarySubtitle,
                ),
                const SizedBox(height: AppSpacing.xl),
                AppSectionHeader(
                  title: l10n.availablePlans,
                  subtitle: l10n.availablePlansSubtitle,
                ),
                const SizedBox(height: AppSpacing.md),
                for (var index = 0; index < catalog.plans.length; index++) ...[
                  PlanCard(
                    plan: catalog.plans[index],
                    onPressed: () =>
                        _showPlanActionFeedback(context, catalog.plans[index]),
                  ),
                  if (index != catalog.plans.length - 1)
                    const SizedBox(height: AppSpacing.md),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPlanActionFeedback(BuildContext context, Plan plan) {
    final l10n = appL10n(context);
    final message = plan.isRecommended
        ? l10n.enterpriseUpgradeComingSoon
        : l10n.planSelectionComingSoon(plan.name);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
