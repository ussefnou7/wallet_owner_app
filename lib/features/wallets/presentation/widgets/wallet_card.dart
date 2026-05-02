import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/formatters/app_date_formatter.dart';
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F17202A),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
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
            totalLabel: l10n.totalProfitLabel,
            walletProfit: wallet.walletProfit,
            cashProfit: wallet.cashProfit,
            totalProfit: totalProfit,
            noCollectionYetLabel: l10n.noCollectionYet,
            lastCollectionWithDate: l10n.lastCollectionWithDate,
            lastCollectionWithDateByName: l10n.lastCollectionWithDateByName,
            collectedAt: wallet.collectedAt,
            collectedByName: wallet.collectedByName,
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
    required this.noCollectionYetLabel,
    required this.lastCollectionWithDate,
    required this.lastCollectionWithDateByName,
    required this.collectedAt,
    required this.collectedByName,
    required this.collectProfitLabel,
    this.onCollectProfit,
  });

  final String walletProfitLabel;
  final String cashProfitLabel;
  final String totalLabel;
  final double walletProfit;
  final double cashProfit;
  final double totalProfit;
  final String noCollectionYetLabel;
  final String Function(String date) lastCollectionWithDate;
  final String Function(String date, String name) lastCollectionWithDateByName;
  final DateTime? collectedAt;
  final String? collectedByName;
  final String collectProfitLabel;
  final VoidCallback? onCollectProfit;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    final formattedDate = collectedAt == null
        ? null
        : AppDateFormatter.smart(collectedAt!, locale: locale);
    final collectorName = collectedByName?.trim();
    final footerText = switch ((formattedDate, collectorName)) {
      (null, _) => noCollectionYetLabel,
      (final date?, final name?) when name.isNotEmpty =>
        lastCollectionWithDateByName(date, name),
      (final date?, _) => lastCollectionWithDate(date),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _ProfitMetricTile(
                label: walletProfitLabel,
                value: walletProfit,
                icon: Icons.account_balance_wallet_outlined,
                iconColor: AppColors.primary,
                backgroundColor: AppColors.primarySoft,
                borderColor: AppColors.border,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _ProfitMetricTile(
                label: cashProfitLabel,
                value: cashProfit,
                icon: Icons.payments_outlined,
                iconColor: AppColors.success,
                backgroundColor: AppColors.successSoft,
                borderColor: AppColors.border,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _ProfitMetricTile(
          label: totalLabel,
          value: totalProfit,
          icon: Icons.trending_up_rounded,
          iconColor: AppColors.primary,
          backgroundColor: AppColors.primarySoft,
          borderColor: const Color(0x331459C2),
          isHighlighted: true,
        ),
        const SizedBox(height: AppSpacing.md),
        const Divider(height: 1),
        const SizedBox(height: AppSpacing.sm),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _ProfitCollectionInfo(value: footerText),
            ),
            if (onCollectProfit != null) ...[
              const SizedBox(width: AppSpacing.sm),
              AppCardActionButton(
                label: collectProfitLabel,
                tooltip: collectProfitLabel,
                icon: Icons.payments_outlined,
                foregroundColor: AppColors.success,
                backgroundColor: AppColors.successSoft,
                onPressed: onCollectProfit,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _ProfitMetricTile extends StatelessWidget {
  const _ProfitMetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    this.isHighlighted = false,
  });

  final String label;
  final double value;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.82),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              formatCurrency(value),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: isHighlighted ? AppColors.primary : AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitCollectionInfo extends StatelessWidget {
  const _ProfitCollectionInfo({required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.start,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
