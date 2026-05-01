import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/formatters/app_date_formatter.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../transactions/presentation/controllers/transactions_controller.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../providers/dashboard_provider.dart';

class UserDashboardPage extends ConsumerStatefulWidget {
  const UserDashboardPage({super.key});

  @override
  ConsumerState<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends ConsumerState<UserDashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      ref.invalidate(userDashboardOverviewProvider);
      ref.invalidate(transactionsControllerProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final overviewAsync = ref.watch(userDashboardOverviewProvider);
    final transactionsState = ref.watch(transactionsControllerProvider);
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;
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
            title: l10n.userDashboardTitle,
            subtitle: l10n.userDashboardSubtitle,
          ),
          const SizedBox(height: AppSpacing.sm),
          _PeriodChip(label: l10n.dashboardToday),
          const SizedBox(height: AppSpacing.lg),
          overviewAsync.when(
            loading: () => const _MetricsLoadingState(),
            error: (error, stackTrace) => AppErrorState(
              message: ErrorMessageMapper.getLocalizedMessage(
                context,
                error,
                fallbackMessage: l10n.userDashboardUnableToLoadSummary,
              ),
              compact: true,
              onRetry: () => ref.invalidate(userDashboardOverviewProvider),
            ),
            data: (overview) => _MetricsContent(overview: overview),
          ),
          const SizedBox(height: AppSpacing.md),
          _CreateTransactionCard(
            label: l10n.createTransaction,
            onTap: () => context.go(AppRoutes.userCreateTransaction),
          ),
          const SizedBox(height: AppSpacing.lg),
          _RecentTransactionsCard(transactionsState: transactionsState),
        ],
      ),
    );
  }
}

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(AppRadii.xl),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _MetricsContent extends StatelessWidget {
  const _MetricsContent({required this.overview});

  final DashboardOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      children: [
        _MetricRow.amount(
          label: l10n.dashboardCredits,
          value: overview.totalCredits,
          icon: Icons.south_west_rounded,
          foregroundColor: AppColors.success,
          backgroundColor: AppColors.successSoft,
        ),
        const SizedBox(height: AppSpacing.md),
        _MetricRow.amount(
          label: l10n.dashboardDebits,
          value: overview.totalDebits,
          icon: Icons.north_east_rounded,
          foregroundColor: AppColors.danger,
          backgroundColor: AppColors.dangerSoft,
        ),
        if (overview.transactionCount > 0) ...[
          const SizedBox(height: AppSpacing.md),
          _MetricRow.count(
            label: l10n.transactionCount,
            value: overview.transactionCount,
            icon: Icons.receipt_long_outlined,
            foregroundColor: AppColors.textPrimary,
            backgroundColor: AppColors.surfaceVariant,
          ),
        ],
      ],
    );
  }
}

class _MetricsLoadingState extends StatelessWidget {
  const _MetricsLoadingState();

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Column(
      children: [
        _MetricRow.loading(label: l10n.dashboardCredits),
        const SizedBox(height: AppSpacing.md),
        _MetricRow.loading(label: l10n.dashboardDebits),
        const SizedBox(height: AppSpacing.md),
        _MetricRow.loading(label: l10n.transactionCount),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow._({
    required this.label,
    required this.valueText,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    this.isLoading = false,
  });

  factory _MetricRow.amount({
    required String label,
    required double value,
    required IconData icon,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return _MetricRow._(
      label: label,
      valueText: formatCurrency(value),
      icon: icon,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  factory _MetricRow.count({
    required String label,
    required int value,
    required IconData icon,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return _MetricRow._(
      label: label,
      valueText: '$value',
      icon: icon,
      foregroundColor: foregroundColor,
      backgroundColor: backgroundColor,
    );
  }

  factory _MetricRow.loading({required String label}) {
    return _MetricRow._(
      label: label,
      valueText: '...',
      icon: Icons.more_horiz_rounded,
      foregroundColor: AppColors.textMuted,
      backgroundColor: AppColors.surfaceVariant,
      isLoading: true,
    );
  }

  final String label;
  final String valueText;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Icon(icon, color: foregroundColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  isLoading ? '...' : valueText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CreateTransactionCard extends StatelessWidget {
  const _CreateTransactionCard({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primary,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(AppRadii.md),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard({required this.transactionsState});

  final TransactionsListState transactionsState;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

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
          AppSectionHeader(
            title: l10n.recentTransactions,
            actionLabel: l10n.viewAll,
            onActionPressed: () => context.go(AppRoutes.userTransactions),
          ),
          const SizedBox(height: AppSpacing.md),
          if (transactionsState.isInitialLoading)
            AppLoadingView(message: l10n.loadingTransactions)
          else if (transactionsState.errorMessage != null &&
              transactionsState.transactions.isEmpty)
            AppErrorState(
              message: ErrorMessageMapper.getLocalizedMessage(
                context,
                transactionsState.errorMessage,
                fallbackMessage: l10n.unableToLoadTransactions,
              ),
              compact: true,
            )
          else ...[
            () {
              final visible = [...transactionsState.transactions]
                ..sort((a, b) => _displayDate(b).compareTo(_displayDate(a)));

              if (visible.isEmpty) {
                return AppEmptyState(
                  title: l10n.noRecentTransactions,
                  message: l10n.recentTransactionsEmptyMessage,
                  icon: Icons.receipt_long_outlined,
                );
              }

              final recent = visible.take(4).toList(growable: false);
              return Column(
                children: [
                  for (var index = 0; index < recent.length; index++) ...[
                    _UserRecentTransactionTile(transaction: recent[index]),
                    if (index != recent.length - 1)
                      const Divider(height: AppSpacing.lg, thickness: 0.6),
                  ],
                ],
              );
            }(),
          ],
        ],
      ),
    );
  }

  DateTime _displayDate(TransactionRecord transaction) {
    return transaction.occurredAt ?? transaction.createdAt ?? transaction.date;
  }
}

class _UserRecentTransactionTile extends StatelessWidget {
  const _UserRecentTransactionTile({required this.transaction});

  final TransactionRecord transaction;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;
    final isCredit = transaction.type == TransactionEntryType.credit;
    final typeLabel = switch (transaction.type) {
      TransactionEntryType.credit => l10n.transactionCredit,
      TransactionEntryType.debit => l10n.transactionDebit,
      TransactionEntryType.unknown => l10n.unknown,
    };

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.md),
        onTap: () => context.go(AppRoutes.userTransactions),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
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
                      transaction.walletName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      AppDateFormatter.full(_displayDate, locale: locale),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatCurrency(transaction.amount),
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
  }

  DateTime get _displayDate {
    return transaction.occurredAt ?? transaction.createdAt ?? transaction.date;
  }
}
