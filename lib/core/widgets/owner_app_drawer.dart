import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

class OwnerAppDrawer extends ConsumerWidget {
  const OwnerAppDrawer({required this.currentRoute, super.key});

  final String currentRoute;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authControllerProvider).session;
    final ownerName = session?.displayName ?? 'Wallet Owner';
    final username = session?.username ?? 'owner';
    final roleLabel = session?.roleLabel ?? 'OWNER';
    final items = [
      const _DrawerItemData(
        label: 'Branches',
        route: AppRoutes.branches,
        icon: Icons.storefront_outlined,
      ),
      const _DrawerItemData(
        label: 'Users',
        route: AppRoutes.users,
        icon: Icons.people_outline_rounded,
      ),
      const _DrawerItemData(
        label: 'Plans',
        route: AppRoutes.plans,
        icon: Icons.workspace_premium_outlined,
      ),
      const _DrawerItemData(
        label: 'Settings',
        route: AppRoutes.settings,
        icon: Icons.settings_outlined,
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
                  'Logout',
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: AppColors.danger),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  await ref.read(authControllerProvider.notifier).signOut();
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
  });

  final String label;
  final String route;
  final IconData icon;
}
