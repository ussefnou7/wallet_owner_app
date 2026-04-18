import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_shadows.dart';
import '../constants/app_spacing.dart';

class AppMetricCard extends StatelessWidget {
  const AppMetricCard({
    required this.label,
    required this.value,
    this.helperText,
    this.icon,
    this.highlighted = false,
    this.valueColor,
    super.key,
  });

  final String label;
  final String value;
  final String? helperText;
  final IconData? icon;
  final bool highlighted;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = highlighted ? AppColors.primary : AppColors.surface;
    final borderColor = highlighted ? AppColors.primary : AppColors.border;
    final titleColor = highlighted ? Colors.white70 : AppColors.textSecondary;
    final resolvedValueColor =
        valueColor ?? (highlighted ? Colors.white : AppColors.textPrimary);
    final helperColor = highlighted ? Colors.white70 : AppColors.textMuted;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: borderColor),
        boxShadow: highlighted ? AppShadows.md : AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null)
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: highlighted
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadii.md),
                  ),
                  child: Icon(
                    icon,
                    color: highlighted ? Colors.white : AppColors.primary,
                    size: 20,
                  ),
                ),
              if (icon != null) const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: titleColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: resolvedValueColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (helperText != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              helperText!,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: helperColor),
            ),
          ],
        ],
      ),
    );
  }
}
