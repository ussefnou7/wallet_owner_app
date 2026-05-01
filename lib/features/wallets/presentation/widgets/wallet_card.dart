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
    this.onCollectProfit,
    super.key,
  });

  final Wallet wallet;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onCollectProfit;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final subtitleParts = <String>[
      if (wallet.branchName?.trim().isNotEmpty == true)
        wallet.branchName!.trim(),
      if (wallet.rawType?.trim().isNotEmpty == true) wallet.rawType!.trim(),
    ];
    final totalProfit = wallet.walletProfit + wallet.cashProfit;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ActionsColumn(
                isActive: wallet.status == WalletStatus.active,
                activeLabel: l10n.active,
                inactiveLabel: l10n.inactive,
                editLabel: l10n.edit,
                editTooltip: l10n.editWallet,
                deleteLabel: l10n.delete,
                deleteTooltip: l10n.deleteWallet,
                onEdit: onEdit,
                onDelete: onDelete,
              ),
              const Spacer(),
              Expanded(
                flex: 4,
                child: _WalletInfoColumn(
                  wallet: wallet,
                  subtitle: subtitleParts.join(' • '),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _ConsumptionCard(
                  title: l10n.walletDailyConsumption,
                  percent: wallet.dailyPercent,
                  spent: wallet.dailySpent,
                  limit: wallet.dailyLimit,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _ConsumptionCard(
                  title: l10n.walletMonthlyConsumption,
                  percent: wallet.monthlyPercent,
                  spent: wallet.monthlySpent,
                  limit: wallet.monthlyLimit,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          _ProfitSection(
            walletProfitLabel: l10n.walletProfitLabel,
            cashProfitLabel: l10n.walletCashProfit,
            totalLabel: l10n.walletTotalLabel,
            walletProfit: wallet.walletProfit,
            cashProfit: wallet.cashProfit,
            totalProfit: totalProfit,
            collectProfitLabel: l10n.collectProfit,
            onCollectProfit: onCollectProfit,
          ),
        ],
      ),
    );
  }
}

class _ActionsColumn extends StatelessWidget {
  const _ActionsColumn({
    required this.isActive,
    required this.activeLabel,
    required this.inactiveLabel,
    required this.editLabel,
    required this.editTooltip,
    required this.deleteLabel,
    required this.deleteTooltip,
    this.onEdit,
    this.onDelete,
  });

  final bool isActive;
  final String activeLabel;
  final String inactiveLabel;
  final String editLabel;
  final String editTooltip;
  final String deleteLabel;
  final String deleteTooltip;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppStatusIndicator(
          label: isActive ? activeLabel : inactiveLabel,
          isActive: isActive,
          inactiveColor: AppColors.textMuted,
        ),
        if (onEdit != null || onDelete != null) const SizedBox(height: 8),
        if (onEdit != null)
          AppCardActionButton(
            label: editLabel,
            tooltip: editTooltip,
            icon: Icons.edit_outlined,
            foregroundColor: AppColors.primary,
            backgroundColor: AppColors.primarySoft,
            onPressed: onEdit,
          ),
        if (onEdit != null && onDelete != null) const SizedBox(height: 8),
        if (onDelete != null)
          AppCardActionButton(
            label: deleteLabel,
            tooltip: deleteTooltip,
            icon: Icons.delete_outline_rounded,
            foregroundColor: AppColors.danger,
            backgroundColor: AppColors.dangerSoft,
            onPressed: onDelete,
          ),
      ],
    );
  }
}

class _WalletInfoColumn extends StatelessWidget {
  const _WalletInfoColumn({required this.wallet, required this.subtitle});

  final Wallet wallet;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          wallet.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        if (subtitle.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
        const SizedBox(height: AppSpacing.sm),
        Text(
          appL10n(context).walletCurrentBalance,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formatCurrency(wallet.balance),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ],
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
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${percent.toStringAsFixed(percent.truncateToDouble() == percent ? 0 : 1)}%',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ProfitSection extends StatelessWidget {
  const _ProfitSection({
    required this.walletProfitLabel,
    required this.cashProfitLabel,
    required this.totalLabel,
    required this.walletProfit,
    required this.cashProfit,
    required this.totalProfit,
    required this.collectProfitLabel,
    this.onCollectProfit,
  });

  final String walletProfitLabel;
  final String cashProfitLabel;
  final String totalLabel;
  final double walletProfit;
  final double cashProfit;
  final double totalProfit;
  final String collectProfitLabel;
  final VoidCallback? onCollectProfit;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (onCollectProfit != null)
          AppCardActionButton(
            label: collectProfitLabel,
            tooltip: collectProfitLabel,
            icon: Icons.payments_outlined,
            foregroundColor: AppColors.success,
            backgroundColor: AppColors.successSoft,
            onPressed: onCollectProfit,
          ),
        const Spacer(),
        _ProfitValuesColumn(
          walletProfit: walletProfit,
          cashProfit: cashProfit,
          totalProfit: totalProfit,
        ),
        const SizedBox(width: 32),
        Expanded(
          child: _ProfitLabelsColumn(
            walletProfitLabel: walletProfitLabel,
            cashProfitLabel: cashProfitLabel,
            totalLabel: totalLabel,
          ),
        ),
      ],
    );
  }
}

class _ProfitValuesColumn extends StatelessWidget {
  const _ProfitValuesColumn({
    required this.walletProfit,
    required this.cashProfit,
    required this.totalProfit,
  });

  final double walletProfit;
  final double cashProfit;
  final double totalProfit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          formatCurrency(walletProfit),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formatCurrency(cashProfit),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          formatCurrency(totalProfit),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _ProfitLabelsColumn extends StatelessWidget {
  const _ProfitLabelsColumn({
    required this.walletProfitLabel,
    required this.cashProfitLabel,
    required this.totalLabel,
  });

  final String walletProfitLabel;
  final String cashProfitLabel;
  final String totalLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          walletProfitLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          cashProfitLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          totalLabel,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
