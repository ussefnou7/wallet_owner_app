import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatters/app_date_formatter.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';

class CompactTransactionListItem extends StatelessWidget {
  const CompactTransactionListItem({
    required this.walletName,
    required this.amount,
    required this.isCredit,
    required this.typeLabel,
    required this.recordedAt,
    this.subtitle,
    this.description,
    this.createdByUsername,
    this.onTap,
    this.wrapInCard = false,
    super.key,
  });

  final String walletName;
  final double amount;
  final bool isCredit;
  final String typeLabel;
  final DateTime? recordedAt;
  final String? subtitle;
  final String? description;
  final String? createdByUsername;
  final VoidCallback? onTap;
  final bool wrapInCard;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;
    final resolvedSubtitle = subtitle?.trim().isNotEmpty == true
        ? subtitle!.trim()
        : recordedAt == null
        ? l10n.notAvailable
        : AppDateFormatter.smart(recordedAt!, locale: locale);
    final creator = createdByUsername?.trim();
    final showCreator = creator != null && creator.isNotEmpty;
    final note = description?.trim();
    final showDescription = note != null && note.isNotEmpty;

    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: isCredit
                    ? AppColors.primarySoft
                    : AppColors.dangerSoft,
                child: Icon(
                  isCredit
                      ? Icons.arrow_downward_rounded
                      : Icons.arrow_upward_rounded,
                  color: isCredit ? AppColors.success : AppColors.danger,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      walletName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      resolvedSubtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (showDescription) ...[
                      const SizedBox(height: 2),
                      Text(
                        note,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                    if (showCreator) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.createdBy(creator),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatCurrency(amount),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isCredit ? AppColors.success : AppColors.danger,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    typeLabel,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: isCredit ? AppColors.success : AppColors.danger,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (!wrapInCard) {
      return content;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: content,
    );
  }
}
