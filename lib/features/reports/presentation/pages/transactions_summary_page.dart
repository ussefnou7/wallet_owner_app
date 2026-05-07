import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../../../core/formatters/app_date_formatter.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_dropdown_field.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_page_scaffold.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../branches/domain/entities/branch.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../users/domain/entities/app_user.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/domain/entities/wallet_option.dart';
import '../../domain/entities/transaction_summary_filters.dart';
import '../../domain/entities/transaction_summary_response.dart';
import '../controllers/report_wallet_options_provider.dart';
import '../controllers/transactions_summary_controller.dart';
import '../widgets/report_compact_metric_card.dart';
import '../widgets/report_empty_state.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_filter_bottom_sheet.dart';
import '../widgets/transaction_report_card.dart';

class TransactionsSummaryPage extends ConsumerWidget {
  const TransactionsSummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(transactionSummaryControllerProvider);
    final controller = ref.read(transactionSummaryControllerProvider.notifier);
    final branchesAsync = ref.watch(branchesControllerProvider);
    final usersAsync = ref.watch(usersControllerProvider);
    final walletOptionsAsync = ref.watch(
      reportWalletOptionsProvider(state.filters.branchId),
    );

    final filterItems = _buildFilterItems(
      filters: state.filters,
      branches: branchesAsync.valueOrNull ?? const <Branch>[],
      users: usersAsync.valueOrNull ?? const <AppUser>[],
      wallets: walletOptionsAsync.valueOrNull ?? const <WalletOption>[],
    );

    final errorMessage = state.error == null
        ? null
        : ErrorMessageMapper.getLocalizedMessage(
            context,
            state.error,
            fallbackMessage: l10n.unableToLoadTransactionsSummaryReport,
          );

    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;

    return AppPageScaffold(
      title: l10n.transactionsSummaryReportTitle,
      embedded: true,
      maxWidth: AppDimensions.contentMaxWidth,
      child: RefreshIndicator(
        onRefresh: controller.refresh,
        child: ListView(
          padding: EdgeInsets.only(
            top: AppSpacing.xs,
            bottom: bottomContentPadding,
          ),
          children: [
            AppSectionHeader(
              title: l10n.transactionsSummaryReportTitle,
              subtitle: l10n.transactionsSummaryReportDescription,
            ),
            const SizedBox(height: AppSpacing.md),
            ReportFilterBar(
              title: l10n.filters,
              summary: _formatDateRange(
                context,
                state.filters.dateFrom,
                state.filters.dateTo,
              ),
              items: filterItems,
              isRefreshing: state.isRefreshing,
              onRefresh: controller.refresh,
              onTap: () => _showFiltersSheet(
                context,
                ref,
                initialFilters: state.filters,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (errorMessage != null && state.response != null) ...[
              AppErrorState(message: errorMessage, compact: true),
              const SizedBox(height: AppSpacing.md),
            ],
            ..._buildBody(
              context,
              ref,
              state: state,
              errorMessage: errorMessage,
              locale: locale,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBody(
    BuildContext context,
    WidgetRef ref, {
    required TransactionsSummaryState state,
    required String? errorMessage,
    required String locale,
  }) {
    final l10n = appL10n(context);
    final controller = ref.read(transactionSummaryControllerProvider.notifier);

    if (state.isLoading && state.response == null) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: AppLoadingView(message: l10n.loadingTransactionsSummaryReport),
        ),
      ];
    }

    if (state.response == null) {
      return [
        AppErrorState(
          message: errorMessage ?? l10n.unableToLoadTransactionsSummaryReport,
          onRetry: controller.retry,
        ),
      ];
    }

    final summary = state.response!.summary;
    final highestTransaction = state.response!.highestTransaction;
    final balanceLabel = switch (summary.balanceScope) {
      BalanceScope.wallet => l10n.walletBalance,
      BalanceScope.branch => l10n.branchWalletsBalance,
      BalanceScope.none => null,
    };

    final metrics = _summaryMetrics(l10n, summary);

    return [
      for (var index = 0; index < metrics.length; index++) ...[
        ReportCompactMetricCard(
          label: metrics[index].label,
          value: metrics[index].value,
          icon: metrics[index].icon,
          accentColor: metrics[index].accentColor,
        ),
        if (index != metrics.length - 1 || balanceLabel != null)
          const SizedBox(height: AppSpacing.sm),
      ],
      if (balanceLabel != null)
        ReportCompactMetricCard(
          label: balanceLabel,
          value: summary.balance == null
              ? l10n.notAvailable
              : formatCurrency(summary.balance!),
          icon: summary.balanceScope == BalanceScope.wallet
              ? Icons.account_balance_wallet_outlined
              : Icons.account_balance_rounded,
          accentColor: AppColors.accent,
        ),
      const SizedBox(height: AppSpacing.lg),
      AppSectionHeader(title: l10n.highestTransactionTitle),
      const SizedBox(height: AppSpacing.sm),
      if (highestTransaction == null)
        ReportEmptyState(
          title: l10n.noHighestTransactionTitle,
          message: l10n.noHighestTransactionMessage,
          icon: Icons.insights_outlined,
        )
      else
        TransactionReportCard(
          typeLabel: _transactionTypeLabel(context, highestTransaction.type),
          amount: formatCurrency(highestTransaction.amount),
          walletName: highestTransaction.walletName ?? l10n.notAvailable,
          branchName: highestTransaction.branchName ?? l10n.notAvailable,
          createdByUsername:
              highestTransaction.createdByUsername ?? l10n.notAvailable,
          occurredAt: highestTransaction.occurredAt == null
              ? l10n.notAvailable
              : AppDateFormatter.full(
                  highestTransaction.occurredAt!.toLocal(),
                  locale: locale,
                ),
          description: highestTransaction.description,
          isCredit: highestTransaction.type == TransactionEntryType.credit,
        ),
    ];
  }

  Future<void> _showFiltersSheet(
    BuildContext context,
    WidgetRef ref, {
    required TransactionSummaryFilters initialFilters,
  }) async {
    final result = await showModalBottomSheet<TransactionSummaryFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _TransactionsSummaryFilterSheet(initialFilters: initialFilters);
      },
    );

    if (result == null) {
      return;
    }

    await ref
        .read(transactionSummaryControllerProvider.notifier)
        .applyFilters(result);
  }

  List<ReportFilterBarItem> _buildFilterItems({
    required TransactionSummaryFilters filters,
    required List<Branch> branches,
    required List<AppUser> users,
    required List<WalletOption> wallets,
  }) {
    final items = <ReportFilterBarItem>[];

    final selectedBranch = _firstWhereOrNull(
      branches,
      (branch) => branch.id == filters.branchId,
    );
    if (selectedBranch != null) {
      items.add(
        ReportFilterBarItem(
          icon: Icons.storefront_outlined,
          label: selectedBranch.name,
        ),
      );
    }

    final selectedWallet = _firstWhereOrNull(
      wallets,
      (wallet) => wallet.id == filters.walletId,
    );
    if (selectedWallet != null) {
      items.add(
        ReportFilterBarItem(
          icon: Icons.account_balance_wallet_outlined,
          label: selectedWallet.name,
        ),
      );
    }

    final selectedUser = _firstWhereOrNull(
      users,
      (user) => user.id == filters.createdBy,
    );
    if (selectedUser != null) {
      items.add(
        ReportFilterBarItem(
          icon: Icons.person_outline_rounded,
          label: selectedUser.username,
        ),
      );
    }

    return items;
  }
}

class _TransactionsSummaryFilterSheet extends ConsumerStatefulWidget {
  const _TransactionsSummaryFilterSheet({required this.initialFilters});

  final TransactionSummaryFilters initialFilters;

  @override
  ConsumerState<_TransactionsSummaryFilterSheet> createState() =>
      _TransactionsSummaryFilterSheetState();
}

class _TransactionsSummaryFilterSheetState
    extends ConsumerState<_TransactionsSummaryFilterSheet> {
  late DateTime _dateFrom;
  late DateTime _dateTo;
  String? _selectedBranchId;
  String? _selectedWalletId;
  String? _selectedCreatedBy;

  @override
  void initState() {
    super.initState();
    final fallback = TransactionSummaryFilters.currentMonth();
    _dateFrom = widget.initialFilters.dateFrom ?? fallback.dateFrom!;
    _dateTo = widget.initialFilters.dateTo ?? fallback.dateTo!;
    _selectedBranchId = widget.initialFilters.branchId;
    _selectedWalletId = widget.initialFilters.walletId;
    _selectedCreatedBy = widget.initialFilters.createdBy;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final materialLocalizations = MaterialLocalizations.of(context);
    final branchesAsync = ref.watch(branchesControllerProvider);
    final usersAsync = ref.watch(usersControllerProvider);
    final walletOptionsAsync = ref.watch(
      reportWalletOptionsProvider(_selectedBranchId),
    );

    final branches = branchesAsync.valueOrNull ?? const <Branch>[];
    final users = usersAsync.valueOrNull ?? const <AppUser>[];
    final wallets = walletOptionsAsync.valueOrNull ?? const <WalletOption>[];

    return ReportFilterBottomSheet(
      title: l10n.filters,
      subtitle: l10n.reportFiltersSubtitle,
      primaryLabel: l10n.applyFilters,
      secondaryLabel: l10n.clearFilters,
      onPrimaryPressed: () {
        Navigator.of(context).pop(
          TransactionSummaryFilters(
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            branchId: _selectedBranchId,
            walletId: _selectedWalletId,
            createdBy: _selectedCreatedBy,
          ),
        );
      },
      onSecondaryPressed: () {
        Navigator.of(context).pop(TransactionSummaryFilters.currentMonth());
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _DateField(
            label: l10n.fromDate,
            value: materialLocalizations.formatMediumDate(_dateFrom),
            onTap: () => _pickDate(
              context,
              initialDate: _dateFrom,
              onSelected: (picked) {
                final nextFrom = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                );
                setState(() {
                  _dateFrom = nextFrom;
                  if (_dateTo.isBefore(nextFrom)) {
                    _dateTo = DateTime(
                      picked.year,
                      picked.month,
                      picked.day,
                      23,
                      59,
                      59,
                    );
                  }
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _DateField(
            label: l10n.toDate,
            value: materialLocalizations.formatMediumDate(_dateTo),
            onTap: () => _pickDate(
              context,
              initialDate: _dateTo,
              onSelected: (picked) {
                final nextTo = DateTime(
                  picked.year,
                  picked.month,
                  picked.day,
                  23,
                  59,
                  59,
                );
                setState(() {
                  _dateTo = nextTo;
                  if (_dateFrom.isAfter(nextTo)) {
                    _dateFrom = DateTime(picked.year, picked.month, picked.day);
                  }
                });
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          AppDropdownField<String?>(
            fieldKey: ValueKey('branch-${_selectedBranchId ?? 'all'}'),
            value: _selectedBranchId,
            label: l10n.branchName,
            hintText: branchesAsync.isLoading ? l10n.loadingBranches : l10n.all,
            prefixIcon: const Icon(Icons.storefront_outlined),
            items: _nullableStringItems(
              allLabel: l10n.all,
              currentValue: _selectedBranchId,
              currentValueLabel: branchesAsync.isLoading
                  ? l10n.loading
                  : l10n.notAvailable,
              options: branches
                  .map((branch) => (branch.id, branch.name))
                  .toList(),
            ),
            onChanged: branchesAsync.isLoading
                ? null
                : (value) {
                    setState(() {
                      _selectedBranchId = value;
                      _selectedWalletId = null;
                    });
                  },
          ),
          if (branchesAsync.hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            AppErrorState(message: l10n.unableToLoadBranches, compact: true),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppDropdownField<String?>(
            fieldKey: ValueKey(
              'wallet-${_selectedBranchId ?? 'all'}-${_selectedWalletId ?? 'all'}',
            ),
            value: _selectedWalletId,
            label: l10n.wallet,
            hintText: walletOptionsAsync.isLoading
                ? l10n.loadingWalletOptions
                : l10n.all,
            prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
            items: _nullableStringItems(
              allLabel: l10n.all,
              currentValue: _selectedWalletId,
              currentValueLabel: walletOptionsAsync.isLoading
                  ? l10n.loading
                  : l10n.notAvailable,
              options: wallets
                  .map((wallet) => (wallet.id, wallet.name))
                  .toList(),
            ),
            onChanged: walletOptionsAsync.isLoading
                ? null
                : (value) => setState(() => _selectedWalletId = value),
          ),
          if (walletOptionsAsync.hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            AppErrorState(
              message: l10n.unableToLoadWalletOptions,
              compact: true,
            ),
          ] else if (!walletOptionsAsync.isLoading &&
              wallets.isEmpty &&
              _selectedBranchId != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Text(
                l10n.noWalletsInBranch,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          AppDropdownField<String?>(
            fieldKey: ValueKey('created-by-${_selectedCreatedBy ?? 'all'}'),
            value: _selectedCreatedBy,
            label: l10n.createdByUser,
            hintText: usersAsync.isLoading ? l10n.loadingUsers : l10n.all,
            prefixIcon: const Icon(Icons.person_outline_rounded),
            items: _nullableStringItems(
              allLabel: l10n.all,
              currentValue: _selectedCreatedBy,
              currentValueLabel: usersAsync.isLoading
                  ? l10n.loading
                  : l10n.notAvailable,
              options: users.map((user) => (user.id, user.username)).toList(),
            ),
            onChanged: usersAsync.isLoading
                ? null
                : (value) => setState(() => _selectedCreatedBy = value),
          ),
          if (usersAsync.hasError) ...[
            const SizedBox(height: AppSpacing.xs),
            AppErrorState(message: l10n.unableToLoadUsers, compact: true),
          ],
        ],
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year, now.month, now.day),
    );

    if (picked != null) {
      onSelected(picked);
    }
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.md),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_rounded),
        ),
        child: Text(value),
      ),
    );
  }
}

class _MetricCardData {
  const _MetricCardData({
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor = AppColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;
}

List<_MetricCardData> _summaryMetrics(
  AppLocalizations l10n,
  TransactionSummarySummary summary,
) {
  return [
    _MetricCardData(
      label: l10n.totalCredits,
      value: formatCurrency(summary.totalCredits),
      icon: Icons.arrow_downward_rounded,
      accentColor: AppColors.success,
    ),
    _MetricCardData(
      label: l10n.totalDebits,
      value: formatCurrency(summary.totalDebits),
      icon: Icons.arrow_upward_rounded,
      accentColor: AppColors.danger,
    ),
    _MetricCardData(
      label: l10n.transactionCount,
      value: _formatCount(summary.transactionCount),
      icon: Icons.receipt_long_outlined,
    ),
    _MetricCardData(
      label: l10n.creditCount,
      value: _formatCount(summary.creditCount),
      icon: Icons.trending_up_rounded,
      accentColor: AppColors.success,
    ),
    _MetricCardData(
      label: l10n.debitCount,
      value: _formatCount(summary.debitCount),
      icon: Icons.trending_down_rounded,
      accentColor: AppColors.danger,
    ),
  ];
}

String _formatDateRange(BuildContext context, DateTime? from, DateTime? to) {
  final localizations = MaterialLocalizations.of(context);
  final fromValue = from == null ? null : localizations.formatMediumDate(from);
  final toValue = to == null ? null : localizations.formatMediumDate(to);

  if (fromValue != null && toValue != null) {
    return '$fromValue - $toValue';
  }
  if (fromValue != null) {
    return fromValue;
  }
  if (toValue != null) {
    return toValue;
  }
  return appL10n(context).notAvailable;
}

String _transactionTypeLabel(BuildContext context, TransactionEntryType type) {
  final l10n = appL10n(context);
  return switch (type) {
    TransactionEntryType.credit => l10n.credit,
    TransactionEntryType.debit => l10n.debit,
    TransactionEntryType.unknown => l10n.unknown,
  };
}

String _formatCount(int value) {
  return NumberFormat.decimalPattern().format(value);
}

T? _firstWhereOrNull<T>(Iterable<T> values, bool Function(T value) test) {
  for (final value in values) {
    if (test(value)) {
      return value;
    }
  }
  return null;
}

List<DropdownMenuItem<String?>> _nullableStringItems({
  required String allLabel,
  required String? currentValue,
  required String currentValueLabel,
  required List<(String, String)> options,
}) {
  final items = <DropdownMenuItem<String?>>[
    DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
  ];

  final hasCurrentValue =
      currentValue != null &&
      options.every((option) => option.$1 != currentValue);

  if (hasCurrentValue) {
    items.add(
      DropdownMenuItem<String?>(
        value: currentValue,
        child: Text(currentValueLabel, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  items.addAll(
    options.map(
      (option) => DropdownMenuItem<String?>(
        value: option.$1,
        child: Text(option.$2, overflow: TextOverflow.ellipsis),
      ),
    ),
  );

  return items;
}
