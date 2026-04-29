import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/branches/presentation/controllers/branches_controller.dart';
import '../../features/dashboard/presentation/providers/dashboard_provider.dart';
import '../../features/reports/presentation/controllers/reports_controller.dart';
import '../../features/transactions/presentation/controllers/transactions_controller.dart';
import '../../features/users/presentation/controllers/users_controller.dart';
import '../../features/wallets/presentation/controllers/wallets_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';

class UserAppDrawer extends ConsumerWidget {
  const UserAppDrawer({super.key});

  void _invalidateCachedProviders(WidgetRef ref) {
    ref.invalidate(walletsControllerProvider);
    ref.invalidate(transactionsControllerProvider);
    ref.invalidate(branchesControllerProvider);
    ref.invalidate(usersControllerProvider);
    ref.invalidate(dashboardOverviewProvider);
    ref.invalidate(dashboardTransactionSummaryProvider);
    ref.invalidate(dashboardRecentTransactionsProvider);
    ref.invalidate(reportsControllerProvider);
    ref.invalidate(reportsSelectedTypeProvider);
    ref.invalidate(reportsAppliedFiltersProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final session = ref.watch(authControllerProvider).session;
    final displayName = session?.displayName ?? 'User';
    final username = session?.username ?? 'user';
    final roleLabel = session?.roleLabel ?? 'USER';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadii.xl),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.primarySoft,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                    ),
                    child: const Icon(
                      Icons.account_circle_outlined,
                      color: AppColors.primary,
                      size: AppDimensions.iconLg,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '@$username',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppRadii.xl),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      roleLabel,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                tileColor: AppColors.dangerSoft,
                leading: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                ),
                title: Text(
                  l10n.logout,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.danger),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref.read(authControllerProvider.notifier).signOut();
                  _invalidateCachedProviders(ref);
                  if (context.mounted) {
                    context.go(AppRoutes.login);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
