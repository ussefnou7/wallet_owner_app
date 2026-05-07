import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_shadows.dart';
import '../../../../core/constants/app_spacing.dart';

class TransactionReportCard extends StatelessWidget {
  const TransactionReportCard({
    required this.typeLabel,
    required this.amount,
    required this.walletName,
    required this.branchName,
    required this.createdByUsername,
    required this.occurredAt,
    required this.isCredit,
    this.description,
    super.key,
  });

  final String typeLabel;
  final String amount;
  final String walletName;
  final String branchName;
  final String createdByUsername;
  final String occurredAt;
  final bool isCredit;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final accentColor = isCredit ? AppColors.success : AppColors.danger;
    final icon = isCredit
        ? Icons.arrow_downward_rounded
        : Icons.arrow_upward_rounded;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.xl),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.sm,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadii.lg),
                  ),
                  child: Icon(icon, color: accentColor, size: 20),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        typeLabel,
                        style: Theme.of(
                          context,
                        ).textTheme.labelLarge?.copyWith(color: accentColor),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        amount,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (description != null && description!.trim().isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                description!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.4,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                _TransactionMetaItem(
                  icon: Icons.account_balance_wallet_outlined,
                  value: walletName,
                ),
                _TransactionMetaItem(
                  icon: Icons.storefront_outlined,
                  value: branchName,
                ),
                _TransactionMetaItem(
                  icon: Icons.person_outline_rounded,
                  value: createdByUsername,
                ),
                _TransactionMetaItem(
                  icon: Icons.schedule_rounded,
                  value: occurredAt,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionMetaItem extends StatelessWidget {
  const _TransactionMetaItem({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: AppSpacing.xs),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 220),
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
