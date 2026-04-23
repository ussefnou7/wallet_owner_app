import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';

class TransactionSuccessBanner extends StatelessWidget {
  const TransactionSuccessBanner({required this.referenceId, super.key});

  final String referenceId;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.successSoft,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.16)),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              l10n.transactionSavedRef(referenceId),
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }
}
