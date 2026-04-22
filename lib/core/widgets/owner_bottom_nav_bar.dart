import 'package:flutter/material.dart';

import '../../app/router/app_routes.dart';
import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

class OwnerBottomNavBar extends StatelessWidget {
  const OwnerBottomNavBar({
    required this.currentRoute,
    required this.onRouteSelected,
    super.key,
  });

  final String currentRoute;
  final ValueChanged<String> onRouteSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
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
            boxShadow: const [
              BoxShadow(
                color: Color(0x1417202A),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _NavIconButton(
                    tooltip: 'Transactions',
                    icon: Icons.receipt_long_rounded,
                    selected: currentRoute == AppRoutes.transactions,
                    onTap: () => onRouteSelected(AppRoutes.transactions),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                  child: _CenterActionButton(
                    selected: currentRoute == AppRoutes.createTransaction,
                    onTap: () => onRouteSelected(AppRoutes.createTransaction),
                  ),
                ),
                Expanded(
                  child: _NavIconButton(
                    tooltip: 'Wallets',
                    icon: Icons.account_balance_wallet_rounded,
                    selected: currentRoute == AppRoutes.wallets,
                    onTap: () => onRouteSelected(AppRoutes.wallets),
                  ),
                ),
                Expanded(
                  child: _NavIconButton(
                    tooltip: 'Dashboard',
                    icon: Icons.space_dashboard_rounded,
                    selected: currentRoute == AppRoutes.dashboard,
                    onTap: () => onRouteSelected(AppRoutes.dashboard),
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

class _NavIconButton extends StatelessWidget {
  const _NavIconButton({
    required this.tooltip,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String tooltip;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: onTap,
        iconSize: 24,
        style: IconButton.styleFrom(
          foregroundColor: selected ? AppColors.primary : AppColors.textMuted,
          backgroundColor: selected ? AppColors.primarySoft : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.md),
          ),
        ),
        icon: Icon(icon),
      ),
    );
  }
}

class _CenterActionButton extends StatelessWidget {
  const _CenterActionButton({required this.selected, required this.onTap});

  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'New transaction',
      child: Material(
        color: selected ? AppColors.accent : AppColors.primary,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.xl),
          onTap: onTap,
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(Icons.add_rounded, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}
