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

class OwnerAppDrawer extends ConsumerWidget {
  const OwnerAppDrawer({required this.currentRoute, super.key});

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
    final ownerName = session?.displayName ?? l10n.appName;
    final username = session?.username ?? 'owner';
    final roleLabel = session?.roleLabel ?? 'OWNER';
    final items = [
      _DrawerItemData(
        label: l10n.reports,
        route: AppRoutes.reports,
        icon: Icons.bar_chart_outlined,
      ),
      _DrawerItemData(
        label: l10n.branches,
        route: AppRoutes.branches,
        icon: Icons.storefront_outlined,
      ),
      _DrawerItemData(
        label: l10n.users,
        route: AppRoutes.users,
        icon: Icons.people_outline_rounded,
      ),
      _DrawerItemData(
        label: l10n.support,
        route: AppRoutes.ownerSupport,
        icon: Icons.support_agent_rounded,
      ),
      _DrawerItemData(
        label: l10n.settings,
        route: AppRoutes.settings,
        icon: Icons.settings_outlined,
        key: const Key('settings_nav_item'),
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
                    ownerName,
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
                    _OwnerDrawerTile(
                      data: item,
                      selected: currentRoute == item.route,
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ListTile(
                key: const Key('logout_button'),
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

class _OwnerDrawerTile extends StatelessWidget {
  const _OwnerDrawerTile({required this.data, required this.selected});

  final _DrawerItemData data;
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

class _DrawerItemData {
  const _DrawerItemData({
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
