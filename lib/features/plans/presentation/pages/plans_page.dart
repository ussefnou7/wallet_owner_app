import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_route_back_button.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/owner_app_drawer.dart';
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
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppRouteBackButton(fallbackRoute: AppRoutes.settings),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: plansState.when(
              loading: () =>
                  AppLoadingView(message: l10n.loadingSubscriptionPlans),
              error: (error, stackTrace) => AppErrorState(
                message: l10n.unableToLoadSubscriptionDetails,
                onRetry: () =>
                    ref.read(plansControllerProvider.notifier).reload(),
              ),
              data: (plans) {
                if (plans.isEmpty) {
                  return AppEmptyState(
                    title: l10n.noPlansAvailable,
                    message: l10n.plansEmptyMessage,
                    icon: Icons.workspace_premium_outlined,
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppSectionHeader(
                        title: l10n.subscriptionPlans,
                        subtitle: l10n.subscriptionPlansSubtitle,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      for (var index = 0; index < plans.length; index++) ...[
                        PlanCard(plan: plans[index]),
                        if (index != plans.length - 1)
                          const SizedBox(height: AppSpacing.md),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
