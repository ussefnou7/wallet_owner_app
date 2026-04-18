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
    final items = [
      _DrawerItemData(
        label: 'Dashboard',
        route: AppRoutes.dashboard,
        icon: Icons.grid_view_rounded,
      ),
      _DrawerItemData(
        label: 'Users',
        route: AppRoutes.users,
        icon: Icons.people_outline_rounded,
      ),
      _DrawerItemData(
        label: 'Branches',
        route: AppRoutes.branches,
        icon: Icons.storefront_outlined,
      ),
      _DrawerItemData(
        label: 'Plans',
        route: AppRoutes.plans,
        icon: Icons.workspace_premium_outlined,
      ),
      _DrawerItemData(
        label: 'Request Renewal',
        route: AppRoutes.requestRenewal,
        icon: Icons.autorenew_rounded,
      ),
      _DrawerItemData(
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
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadii.lg),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Icon(
                      Icons.account_balance_wallet_rounded,
                      color: Colors.white,
                      size: AppDimensions.iconMd,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  Text('Wallet Owner'),
                  SizedBox(height: AppSpacing.xs),
                  Text('Tenant Demo Workspace'),
                  SizedBox(height: AppSpacing.xs),
                  Text('OWNER'),
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
            const Divider(),
            ListTile(
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
            const SizedBox(height: AppSpacing.md),
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
    return ListTile(
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
      onTap: () {
        Navigator.of(context).pop();
        context.go(data.route);
      },
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
