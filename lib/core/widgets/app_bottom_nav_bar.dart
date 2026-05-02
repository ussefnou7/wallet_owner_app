import 'package:flutter/material.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_dimensions.dart';
import '../../l10n/generated/app_localizations.dart';
import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';

enum AppBottomNavVariant { owner, user }

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.variant,
    required this.currentRoute,
    required this.onDestinationSelected,
    super.key,
  });

  final AppBottomNavVariant variant;
  final String currentRoute;
  final ValueChanged<String> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final items = _itemsForVariant(variant, l10n);
    final centerIndex = items.indexWhere((item) => item.isPrimaryAction);
    final leadingItems = items.take(centerIndex).toList(growable: false);
    final trailingItems = items.skip(centerIndex + 1).toList(growable: false);
    final centerItem = items[centerIndex];
    return SizedBox(
      height: AppDimensions.floatingBottomNavHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: AppColors.border),
                boxShadow: AppShadows.card,
              ),
              child: SizedBox(
                height: 58,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.md,
                    AppSpacing.xs,
                    AppSpacing.md,
                    AppSpacing.xs,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            for (final item in leadingItems)
                              Expanded(
                                child: _NavItemButton(
                                  item: item,
                                  selected: currentRoute == item.route,
                                  onTap: () =>
                                      onDestinationSelected(item.route),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 68),
                      Expanded(
                        child: Row(
                          children: [
                            for (final item in trailingItems)
                              Expanded(
                                child: _NavItemButton(
                                  item: item,
                                  selected: currentRoute == item.route,
                                  onTap: () =>
                                      onDestinationSelected(item.route),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: _PrimaryNavAction(
              item: centerItem,
              selected: currentRoute == centerItem.route,
              onTap: () => onDestinationSelected(centerItem.route),
            ),
          ),
        ],
      ),
    );
  }

  List<_NavItem> _itemsForVariant(
    AppBottomNavVariant variant,
    AppLocalizations l10n,
  ) {
    return switch (variant) {
      AppBottomNavVariant.owner => [
        _NavItem(
          route: AppRoutes.ownerDashboard,
          label: l10n.dashboard,
          icon: Icons.space_dashboard_outlined,
          selectedIcon: Icons.space_dashboard_rounded,
        ),
        _NavItem(
          route: AppRoutes.ownerWallets,
          label: l10n.wallets,
          icon: Icons.account_balance_wallet_outlined,
          selectedIcon: Icons.account_balance_wallet_rounded,
        ),
        _NavItem(
          route: AppRoutes.ownerCreateTransaction,
          label: l10n.newTransaction,
          icon: Icons.add_rounded,
          selectedIcon: Icons.add_rounded,
          isPrimaryAction: true,
        ),
        _NavItem(
          route: AppRoutes.ownerTransactions,
          label: l10n.transactions,
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long_rounded,
        ),
        _NavItem(
          route: AppRoutes.ownerReports,
          label: l10n.reports,
          icon: Icons.bar_chart_outlined,
          selectedIcon: Icons.bar_chart_rounded,
        ),
      ],
      AppBottomNavVariant.user => [
        _NavItem(
          route: AppRoutes.userDashboard,
          label: l10n.dashboard,
          icon: Icons.space_dashboard_outlined,
          selectedIcon: Icons.space_dashboard_rounded,
        ),
        _NavItem(
          route: AppRoutes.userWallets,
          label: l10n.wallets,
          icon: Icons.account_balance_wallet_outlined,
          selectedIcon: Icons.account_balance_wallet_rounded,
        ),
        _NavItem(
          route: AppRoutes.userCreateTransaction,
          label: l10n.newTransaction,
          icon: Icons.add_rounded,
          selectedIcon: Icons.add_rounded,
          isPrimaryAction: true,
        ),
        _NavItem(
          route: AppRoutes.userTransactions,
          label: l10n.transactions,
          icon: Icons.receipt_long_outlined,
          selectedIcon: Icons.receipt_long_rounded,
        ),
      ],
    };
  }
}

class _NavItem {
  const _NavItem({
    required this.route,
    required this.label,
    required this.icon,
    required this.selectedIcon,
    this.isPrimaryAction = false,
  });

  final String route;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
  final bool isPrimaryAction;
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foregroundColor = selected
        ? AppColors.primary
        : AppColors.textSecondary;

    return Tooltip(
      message: item.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: 34,
                height: 26,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primarySoft : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(
                  selected ? item.selectedIcon : item.icon,
                  color: foregroundColor,
                  size: 20,
                ),
              ),
              const SizedBox(height: 3),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                width: selected ? 12 : 4,
                height: 3,
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadii.xl),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrimaryNavAction extends StatelessWidget {
  const _PrimaryNavAction({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _NavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(28),
          onTap: onTap,
          child: Ink(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: selected ? AppColors.accent : AppColors.primary,
              borderRadius: BorderRadius.circular(22),
              boxShadow: AppShadows.card,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.55),
                width: 1.5,
              ),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
