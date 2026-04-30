import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

class OwnerTopBar extends StatelessWidget {
  const OwnerTopBar({
    required this.title,
    required this.notifications,
    required this.onMenuPressed,
    super.key,
  });

  final String title;
  final Widget notifications;
  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        notifications,
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        _TopBarButton(
          tooltip: 'Menu',
          icon: Icons.menu_rounded,
          onPressed: onMenuPressed,
        ),
      ],
    );
  }
}

class _TopBarButton extends StatelessWidget {
  const _TopBarButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadii.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: onPressed,
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: AppColors.textPrimary),
          ),
        ),
      ),
    );
  }
}
