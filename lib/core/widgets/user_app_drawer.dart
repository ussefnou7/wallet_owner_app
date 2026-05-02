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
import 'app_drawer_version_label.dart';

class UserAppDrawer extends ConsumerWidget {
  const UserAppDrawer({required this.currentRoute, super.key});

  final String currentRoute;

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
    final items = [
      _UserDrawerItemData(
        label: l10n.support,
        route: AppRoutes.userSupport,
        icon: Icons.support_agent_rounded,
        key: const Key('user_support_nav_item'),
      ),
    ];

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
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                children: [
                  for (final item in items)
                    _UserDrawerTile(
                      data: item,
                      selected: currentRoute == item.route,
                    ),
                ],
              ),
            ),
            const AppDrawerVersionLabel(),
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

class _UserDrawerTile extends StatelessWidget {
  const _UserDrawerTile({required this.data, required this.selected});

  final _UserDrawerItemData data;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        key: data.key,
        selected: selected,
        selectedTileColor: AppColors.primarySoft,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        leading: Icon(
          data.icon,
          color: selected ? AppColors.primary : AppColors.textSecondary,
        ),
        title: Text(
          data.label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: selected ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 18),
        onTap: () {
          Navigator.of(context).pop();
          context.go(data.route);
        },
      ),
    );
  }
}

class _UserDrawerItemData {
  const _UserDrawerItemData({
    required this.label,
    required this.route,
    required this.icon,
    this.key,
  });

  final String label;
  final String route;
  final IconData icon;
  final Key? key;
}
