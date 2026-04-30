import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_card_action_button.dart';
import '../../../../core/widgets/app_status_indicator.dart';
import '../../domain/entities/wallet.dart';

class WalletCard extends StatelessWidget {
  const WalletCard({
    required this.wallet,
    this.onEdit,
    this.onDelete,
    super.key,
  });

  final Wallet wallet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    final isActive = wallet.status == WalletStatus.active;
    final l10n = appL10n(context);
    final totalProfit = wallet.walletProfit + wallet.cashProfit;
    final subtitleParts = <String>[
      if (wallet.branchName?.trim().isNotEmpty == true) wallet.branchName!.trim(),
      if (wallet.rawType?.trim().isNotEmpty == true) wallet.rawType!.trim(),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(
        8,
        AppSpacing.sm,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Directionality(
                      textDirection: TextDirection.ltr,
                      child: AppStatusIndicator(
                        label: isActive ? l10n.active : l10n.inactive,
                        isActive: isActive,
                        inactiveColor: AppColors.textMuted,
                      ),
                    ),
                    if (onEdit != null || onDelete != null)
                      const SizedBox(height: AppSpacing.sm),
                    if (onEdit != null)
                      AppCardActionButton(
                        label: l10n.edit,
                        tooltip: l10n.editWallet,
                        icon: Icons.edit_outlined,
                        foregroundColor: AppColors.primary,
                        backgroundColor: AppColors.primarySoft,
                        onPressed: onEdit,
                      ),
                    if (onEdit != null && onDelete != null)
                      const SizedBox(height: 6),
                    if (onDelete != null)
                      AppCardActionButton(
                        label: l10n.delete,
                        tooltip: l10n.deleteWallet,
                        icon: Icons.delete_outline_rounded,
                        foregroundColor: AppColors.danger,
                        backgroundColor: AppColors.dangerSoft,
                        onPressed: onDelete,
                      ),
                  ],
                ),
                const Spacer(),
                Expanded(
                  flex: 4,
                  child: Directionality(
                    textDirection: Directionality.of(context),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wallet.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (subtitleParts.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitleParts.join(' • '),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          l10n.walletCurrentBalance,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          formatCurrency(wallet.balance),
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          LayoutBuilder(
            builder: (context, constraints) {
              final dailyCard = _ConsumptionCard(
                title: l10n.walletDailyConsumption,
                percent: wallet.dailyPercent,
                spent: wallet.dailySpent,
                limit: wallet.dailyLimit,
              );
              final monthlyCard = _ConsumptionCard(
                title: l10n.walletMonthlyConsumption,
                percent: wallet.monthlyPercent,
                spent: wallet.monthlySpent,
                limit: wallet.monthlyLimit,
              );

              if (constraints.maxWidth >= 340) {
                return Row(
                  children: [
                    Expanded(child: dailyCard),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: monthlyCard),
                  ],
                );
              }

              return Column(
                children: [
                  dailyCard,
                  const SizedBox(height: AppSpacing.sm),
                  monthlyCard,
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.sm),
          _ProfitRow(
            label: l10n.walletProfitLabel,
            value: wallet.walletProfit,
          ),
          const SizedBox(height: AppSpacing.xs),
          _ProfitRow(
            label: l10n.walletCashProfit,
            value: wallet.cashProfit,
          ),
          const SizedBox(height: AppSpacing.xs),
          _ProfitRow(
            label: l10n.walletTotalLabel,
            value: totalProfit,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _ConsumptionCard extends StatelessWidget {
  const _ConsumptionCard({
    required this.title,
    required this.percent,
    required this.spent,
    required this.limit,
  });

  final String title;
  final double percent;
  final double spent;
  final double limit;

  @override
  Widget build(BuildContext context) {
    final progress = (percent / 100).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.border,
              color: progress >= 1 ? AppColors.danger : AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${formatCompactNumber(spent)} / ${formatCompactNumber(limit)}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitRow extends StatelessWidget {
  const _ProfitRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final double value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final valueStyle = emphasized
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          )
        : Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          );

    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: emphasized ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Text(
            formatCurrency(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: valueStyle,
          ),
        ),
      ],
    );
  }
}
