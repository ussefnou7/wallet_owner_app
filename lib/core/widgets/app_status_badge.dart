import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';

class AppStatusBadge extends StatelessWidget {
  const AppStatusBadge({
    required this.label,
    this.foregroundColor = AppColors.textSecondary,
    this.backgroundColor = AppColors.surfaceVariant,
    super.key,
  });

  final String label;
  final Color foregroundColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: foregroundColor),
      ),
    );
  }
}
