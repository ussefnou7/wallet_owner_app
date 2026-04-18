import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
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

    return AppPageScaffold(
      title: 'Plans',
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
        loading: () =>
            const AppLoadingView(message: 'Loading subscription plans...'),
        error: (error, stackTrace) => AppErrorState(
          message: 'Unable to load subscription details right now.',
          onRetry: () => ref.read(plansControllerProvider.notifier).reload(),
        ),
        data: (catalog) {
          if (catalog.plans.isEmpty) {
            return const AppEmptyState(
              title: 'No plans available',
              message: 'Subscription plan options will appear here.',
              icon: Icons.workspace_premium_outlined,
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppSectionHeader(
                  title: 'Subscription Plans',
                  subtitle:
                      'Review the current subscription, compare available tiers, and prepare the next upgrade decision.',
                ),
                const SizedBox(height: AppSpacing.md),
                SubscriptionSummaryCard(
                  summary: catalog.currentSubscription,
                  subtitle:
                      'Track plan status and workspace limits before the next renewal window.',
                ),
                const SizedBox(height: AppSpacing.xl),
                const AppSectionHeader(
                  title: 'Available Plans',
                  subtitle:
                      'Mock plan options are ready for comparison and future backend-driven upgrades.',
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
    final message = plan.isRecommended
        ? 'Enterprise upgrade review will be connected in a later phase.'
        : '${plan.name} selection will be connected in a later phase.';

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
