import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/report_option.dart';

class ReportOptionCard extends StatelessWidget {
  const ReportOptionCard({
    required this.option,
    required this.onTap,
    super.key,
  });

  final ReportOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.lg),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.primarySoft,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Icon(
                _iconFromString(option.icon),
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    option.title,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    option.description,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  IconData _iconFromString(String value) {
    switch (value) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;
      case 'compare_arrows':
        return Icons.compare_arrows_rounded;
      case 'trending_up':
        return Icons.trending_up_rounded;
      case 'receipt_long':
        return Icons.receipt_long_outlined;
      case 'storefront':
        return Icons.storefront_outlined;
      case 'people':
        return Icons.people_outline_rounded;
      case 'picture_as_pdf':
        return Icons.picture_as_pdf_outlined;
      case 'table_view':
        return Icons.table_view_outlined;
      default:
        return Icons.description_outlined;
    }
  }
}
