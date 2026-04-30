import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

class NotificationSectionHeader extends StatelessWidget {
  const NotificationSectionHeader({
    required this.title,
    this.actionLabel,
    this.onActionPressed,
    this.enabled = true,
    super.key,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.1,
            ),
          ),
        ),
        if (actionLabel != null && onActionPressed != null)
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.sm),
            child: TextButton(
              onPressed: enabled ? onActionPressed : null,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(actionLabel!),
            ),
          ),
      ],
    );
  }
}
