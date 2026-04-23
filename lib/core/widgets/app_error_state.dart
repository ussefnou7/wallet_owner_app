import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_dimensions.dart';
import '../constants/app_spacing.dart';
import '../localization/app_l10n.dart';

class AppErrorState extends StatelessWidget {
  const AppErrorState({
    required this.message,
    this.onRetry,
    this.compact = false,
    super.key,
  });

  final String message;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final content = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.error_outline, color: AppColors.danger),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.danger),
          ),
        ),
        if (onRetry != null && !compact)
          TextButton(onPressed: onRetry, child: Text(l10n.retry)),
      ],
    );

    return Container(
      width: double.infinity,
      padding: compact
          ? const EdgeInsets.all(AppSpacing.sm)
          : AppDimensions.sectionPadding,
      decoration: BoxDecoration(
        color: AppColors.dangerSoft,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.danger.withValues(alpha: 0.18)),
      ),
      child: content,
    );
  }
}
