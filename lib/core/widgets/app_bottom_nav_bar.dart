import 'package:flutter/material.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentRoute,
    required this.onDestinationSelected,
    super.key,
  });

  final String currentRoute;
  final ValueChanged<String> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final items = [
      _NavItem(
        route: AppRoutes.wallets,
        label: l10n.wallets,
        icon: Icons.account_balance_wallet_outlined,
        selectedIcon: Icons.account_balance_wallet,
      ),
      _NavItem(
        route: AppRoutes.createTransaction,
        label: l10n.create,
        icon: Icons.add_circle_outline,
        selectedIcon: Icons.add_circle,
      ),
      _NavItem(
        route: AppRoutes.reports,
        label: l10n.reports,
        icon: Icons.bar_chart_outlined,
        selectedIcon: Icons.bar_chart,
      ),
    ];

    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.xl),
          border: Border.all(color: AppColors.border),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: AppDimensions.navigationBarHeight,
            child: Row(
              children: [
                for (final item in items)
                  Expanded(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      onTap: () => onDestinationSelected(item.route),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sm,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 40,
                              height: 32,
                              decoration: BoxDecoration(
                                color: currentRoute == item.route
                                    ? AppColors.primarySoft
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(
                                  AppRadii.md,
                                ),
                              ),
                              child: Icon(
                                currentRoute == item.route
                                    ? item.selectedIcon
                                    : item.icon,
                                color: currentRoute == item.route
                                    ? AppColors.primary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              item.label,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(
                                    color: currentRoute == item.route
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}
