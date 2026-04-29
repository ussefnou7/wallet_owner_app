import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../providers/dashboard_provider.dart';
import '../widgets/dashboard_recent_transactions.dart';

class OwnerDashboardPage extends ConsumerStatefulWidget {
  const OwnerDashboardPage({super.key});

  @override
  ConsumerState<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends ConsumerState<OwnerDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.invalidate(dashboardOverviewProvider);
      ref.invalidate(dashboardRecentTransactionsProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(dashboardOverviewProvider);
    final recentTransactions = ref.watch(dashboardRecentTransactionsProvider);
    final l10n = appL10n(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        top: AppSpacing.md,
        bottom: bottomInset + AppDimensions.floatingBottomNavContentPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionHeader(
            title: l10n.portfolioOverview,
            subtitle: l10n.portfolioOverviewSubtitle,
          ),
          const SizedBox(height: AppSpacing.lg),
          overview.when(
            loading: () => const _OverviewLoadingState(),
            error: (error, stackTrace) => AppErrorState(
              message: ErrorMessageMapper.getMessage(error),
              compact: true,
              onRetry: () => ref.invalidate(dashboardOverviewProvider),
            ),
            data: (data) => _OverviewContent(overview: data),
          ),
          const SizedBox(height: AppSpacing.lg),
          recentTransactions.when(
            loading: () =>
                const AppLoadingView(message: 'Loading recent transactions...'),
            error: (error, stackTrace) => AppErrorState(
              message: ErrorMessageMapper.getMessage(error),
              compact: true,
              onRetry: () =>
                  ref.invalidate(dashboardRecentTransactionsProvider),
            ),
            data: (items) => DashboardRecentTransactions(items: items),
          ),
        ],
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _BalanceCard(
          totalBalance: overview.totalBalance,
          activeWallets: overview.activeWallets,
        ),
        const SizedBox(height: AppSpacing.lg),
        _OverviewSummaryGrid(overview: overview),
        if (overview.metrics.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.lg),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: overview.metrics.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              mainAxisExtent: 138,
            ),
            itemBuilder: (context, index) {
              return _OverviewMetricCard(metric: overview.metrics[index]);
            },
          ),
        ],
      ],
    );
  }
}

class _OverviewLoadingState extends StatelessWidget {
  const _OverviewLoadingState();

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Column(
      children: [
        const _BalanceCard(totalBalance: 0, activeWallets: 0, isLoading: true),
        const SizedBox(height: AppSpacing.lg),
        Column(
          children: [
            _OverviewSummaryRow.loading(label: l10n.totalCredits),
            const SizedBox(height: AppSpacing.md),
            _OverviewSummaryRow.loading(label: l10n.totalDebits),
            const SizedBox(height: AppSpacing.md),
            _OverviewSummaryRow.loading(label: l10n.transactionCount),
          ],
        ),
      ],
    );
  }
}

class _OverviewSummaryGrid extends StatelessWidget {
  const _OverviewSummaryGrid({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      children: [
        _OverviewSummaryRow.amount(
          label: l10n.totalCredits,
          subtitle: null,
          value: overview.totalCredits,
          icon: Icons.south_west_rounded,
          foregroundColor: AppColors.success,
          backgroundColor: AppColors.successSoft,
        ),
        const SizedBox(height: AppSpacing.md),
        _OverviewSummaryRow.amount(
          label: l10n.totalDebits,
          subtitle: null,
          value: overview.totalDebits,
          icon: Icons.north_east_rounded,
          foregroundColor: AppColors.danger,
          backgroundColor: AppColors.dangerSoft,
        ),
        const SizedBox(height: AppSpacing.md),
        _OverviewSummaryRow.count(
          label: l10n.transactionCount,
          subtitle: null,
          value: overview.transactionCount,
          icon: Icons.receipt_long_outlined,
          foregroundColor: AppColors.textPrimary,
          backgroundColor: AppColors.surfaceVariant,
        ),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.totalBalance,
    required this.activeWallets,
    this.isLoading = false,
  });

  final double totalBalance;
  final int activeWallets;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.textPrimary,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.totalBalance,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isLoading ? '...' : formatCurrency(totalBalance),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadii.lg),
            ),
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                const Icon(
                  Icons.account_balance_wallet_outlined,
                  color: Colors.white,
                  size: 18,
                ),
                Text(
                  isLoading ? '...' : l10n.activeWalletsCount(activeWallets),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OverviewMetricCard extends StatelessWidget {
  const _OverviewMetricCard({required this.metric});

  final DashboardOverviewMetric? metric;

  @override
  Widget build(BuildContext context) {
    final resolvedMetric = metric;
    final displayLabel = resolvedMetric?.label ?? '';
    final iconColor = _foregroundColor(resolvedMetric?.displayType);
    final iconBackground = _backgroundColor(resolvedMetric?.displayType);
    final iconData = _iconForMetric(resolvedMetric?.key);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
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
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: Icon(iconData, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  displayLabel,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.bottomStart,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: AlignmentDirectional.bottomStart,
                child: Text(
                  _formatMetricValue(resolvedMetric),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatMetricValue(DashboardOverviewMetric? metric) {
    if (metric == null) {
      return '...';
    }

    return switch (metric.displayType) {
      DashboardMetricDisplayType.amount => formatCurrency(
        _asNum(metric.value) ?? 0,
      ),
      DashboardMetricDisplayType.count => formatCompactNumber(
        _asNum(metric.value) ?? 0,
      ),
      DashboardMetricDisplayType.percent => '${_asNum(metric.value) ?? 0}%',
      DashboardMetricDisplayType.boolean => metric.value == true ? 'Yes' : 'No',
      DashboardMetricDisplayType.text => '${metric.value ?? '-'}',
    };
  }

  IconData _iconForMetric(String? key) {
    final normalized = key?.toLowerCase() ?? '';
    if (normalized.contains('credit')) {
      return Icons.south_west_rounded;
    }
    if (normalized.contains('debit')) {
      return Icons.north_east_rounded;
    }
    if (normalized.contains('transaction')) {
      return Icons.receipt_long_outlined;
    }
    if (normalized.contains('profit') || normalized.contains('net')) {
      return Icons.trending_up_rounded;
    }
    if (normalized.contains('wallet')) {
      return Icons.account_balance_wallet_outlined;
    }
    return Icons.bar_chart_rounded;
  }

  Color _backgroundColor(DashboardMetricDisplayType? type) {
    return switch (type) {
      DashboardMetricDisplayType.amount => AppColors.primarySoft,
      DashboardMetricDisplayType.boolean => AppColors.surfaceVariant,
      _ => AppColors.successSoft,
    };
  }

  Color _foregroundColor(DashboardMetricDisplayType? type) {
    return switch (type) {
      DashboardMetricDisplayType.amount => AppColors.primary,
      DashboardMetricDisplayType.boolean => AppColors.textSecondary,
      _ => AppColors.success,
    };
  }

  num? _asNum(Object? value) {
    if (value is num) {
      return value;
    }
    if (value is String) {
      return num.tryParse(value);
    }
    return null;
  }
}

class _OverviewSummaryRow extends StatelessWidget {
  const _OverviewSummaryRow.loading({required this.label})
    : subtitle = null,
      amountValue = null,
      countValue = null,
      icon = Icons.bar_chart_rounded,
      foregroundColor = AppColors.textSecondary,
      backgroundColor = AppColors.surfaceVariant,
      isLoading = true;

  const _OverviewSummaryRow.amount({
    required this.label,
    required this.subtitle,
    required double value,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  }) : amountValue = value,
       countValue = null,
       isLoading = false;

  const _OverviewSummaryRow.count({
    required this.label,
    required this.subtitle,
    required int value,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  }) : amountValue = null,
       countValue = value,
       isLoading = false;

  final String label;
  final String? subtitle;
  final double? amountValue;
  final int? countValue;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final valueText = isLoading
        ? '...'
        : amountValue != null
        ? formatCurrency(amountValue!)
        : formatCompactNumber(countValue ?? 0);

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 76),
      child: Container(
        width: double.infinity,
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
                color: backgroundColor,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Icon(icon, color: foregroundColor, size: 22),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (subtitle != null && !isLoading) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Flexible(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    valueText,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: amountValue != null ? foregroundColor : null,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
