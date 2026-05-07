import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
import '../../../branches/domain/entities/branch.dart';
import '../../../branches/presentation/controllers/branches_controller.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../users/domain/entities/app_user.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/domain/entities/wallet_option.dart';
import '../../domain/entities/transaction_details_filters.dart';
import '../controllers/report_wallet_options_provider.dart';
import '../controllers/transaction_details_controller.dart';
import '../widgets/report_empty_state.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_filter_bottom_sheet.dart';
import '../widgets/transaction_report_card.dart';

class TransactionDetailsPage extends ConsumerWidget {
  const TransactionDetailsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = appL10n(context);
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(transactionDetailsControllerProvider);
    final controller = ref.read(transactionDetailsControllerProvider.notifier);
    final branchesAsync = ref.watch(branchesControllerProvider);
    final usersAsync = ref.watch(usersControllerProvider);
    final walletsAsync = ref.watch(
      reportWalletOptionsProvider(state.filters.branchId),
    );

    final filterItems = _buildFilterItems(
      context,
      filters: state.filters,
      branches: branchesAsync.valueOrNull ?? const <Branch>[],
      users: usersAsync.valueOrNull ?? const <AppUser>[],
      wallets: walletsAsync.valueOrNull ?? const <WalletOption>[],
    );

    final errorMessage = state.error == null
        ? null
        : ErrorMessageMapper.getLocalizedMessage(
            context,
            state.error,
            fallbackMessage: l10n.unableToLoadTransactionDetailsReport,
          );
    final loadMoreErrorMessage = state.loadMoreError == null
        ? null
        : ErrorMessageMapper.getLocalizedMessage(
            context,
            state.loadMoreError,
            fallbackMessage: l10n.unableToLoadTransactionDetailsReport,
          );

    final bottomContentPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;

    return AppPageScaffold(
      title: l10n.transactionDetailsReportTitle,
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
              title: l10n.transactionDetailsReportTitle,
              subtitle: l10n.transactionDetailsReportDescription,
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
            if (errorMessage != null &&
                state.transactions.isNotEmpty &&
                !state.isInitialLoading) ...[
              AppErrorState(message: errorMessage, compact: true),
              const SizedBox(height: AppSpacing.md),
            ],
            ..._buildBody(
              context,
              ref,
              state: state,
              errorMessage: errorMessage,
              loadMoreErrorMessage: loadMoreErrorMessage,
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
    required TransactionDetailsState state,
    required String? errorMessage,
    required String? loadMoreErrorMessage,
    required String locale,
  }) {
    final l10n = appL10n(context);
    final controller = ref.read(transactionDetailsControllerProvider.notifier);

    if (state.isInitialLoading && state.transactions.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
          child: AppLoadingView(message: l10n.loadingTransactionDetailsReport),
        ),
      ];
    }

    if (state.transactions.isEmpty && errorMessage != null) {
      return [AppErrorState(message: errorMessage, onRetry: controller.retry)];
    }

    if (state.transactions.isEmpty) {
      return [
        ReportEmptyState(
          title: l10n.noTransactionsFound,
          message: l10n.noTransactionsMatchedCurrentFilters,
          icon: Icons.receipt_long_outlined,
        ),
      ];
    }

    return [
      for (var index = 0; index < state.transactions.length; index++) ...[
        _TransactionCard(
          transaction: state.transactions[index],
          locale: locale,
        ),
        if (index != state.transactions.length - 1)
          const SizedBox(height: AppSpacing.sm),
      ],
      const SizedBox(height: AppSpacing.md),
      if (loadMoreErrorMessage != null) ...[
        AppErrorState(
          message: loadMoreErrorMessage,
          compact: true,
          onRetry: controller.loadMore,
        ),
        const SizedBox(height: AppSpacing.sm),
      ],
      if (state.isLoadingMore)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Center(child: CircularProgressIndicator()),
        )
      else if (state.hasMore)
        OutlinedButton(
          onPressed: controller.loadMore,
          child: Text(l10n.loadMore),
        )
      else
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Text(
              l10n.endOfResults,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ),
    ];
  }

  Future<void> _showFiltersSheet(
    BuildContext context,
    WidgetRef ref, {
    required TransactionDetailsFilters initialFilters,
  }) async {
    final result = await showModalBottomSheet<TransactionDetailsFilters>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          _TransactionDetailsFilterSheet(initialFilters: initialFilters),
    );

    if (result == null) {
      return;
    }

    await ref
        .read(transactionDetailsControllerProvider.notifier)
        .applyFilters(result);
  }

  List<ReportFilterBarItem> _buildFilterItems(
    BuildContext context, {
    required TransactionDetailsFilters filters,
    required List<Branch> branches,
    required List<AppUser> users,
    required List<WalletOption> wallets,
  }) {
    final l10n = appL10n(context);
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

    if (filters.type != null && filters.type != TransactionEntryType.unknown) {
      items.add(
        ReportFilterBarItem(
          icon: filters.type == TransactionEntryType.credit
              ? Icons.arrow_downward_rounded
              : Icons.arrow_upward_rounded,
          label: switch (filters.type) {
            TransactionEntryType.credit => l10n.credit,
            TransactionEntryType.debit => l10n.debit,
            _ => l10n.allTypes,
          },
        ),
      );
    }

    return items;
  }
}

class _TransactionDetailsFilterSheet extends ConsumerStatefulWidget {
  const _TransactionDetailsFilterSheet({required this.initialFilters});

  final TransactionDetailsFilters initialFilters;

  @override
  ConsumerState<_TransactionDetailsFilterSheet> createState() =>
      _TransactionDetailsFilterSheetState();
}

class _TransactionDetailsFilterSheetState
    extends ConsumerState<_TransactionDetailsFilterSheet> {
  late DateTime _dateFrom;
  late DateTime _dateTo;
  String? _selectedBranchId;
  String? _selectedWalletId;
  String? _selectedCreatedBy;
  TransactionEntryType? _selectedType;

  @override
  void initState() {
    super.initState();
    final fallback = TransactionDetailsFilters.currentMonth();
    _dateFrom = widget.initialFilters.dateFrom ?? fallback.dateFrom!;
    _dateTo = widget.initialFilters.dateTo ?? fallback.dateTo!;
    _selectedBranchId = widget.initialFilters.branchId;
    _selectedWalletId = widget.initialFilters.walletId;
    _selectedCreatedBy = widget.initialFilters.createdBy;
    _selectedType = widget.initialFilters.type;
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
          TransactionDetailsFilters(
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            branchId: _selectedBranchId,
            walletId: _selectedWalletId,
            createdBy: _selectedCreatedBy,
            type: _selectedType,
          ),
        );
      },
      onSecondaryPressed: () {
        Navigator.of(context).pop(TransactionDetailsFilters.currentMonth());
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
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(AppRadii.md),
              ),
              child: Text(
                l10n.noWalletsInBranch,
                style: Theme.of(context).textTheme.bodySmall,
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
          const SizedBox(height: AppSpacing.sm),
          AppDropdownField<TransactionEntryType?>(
            fieldKey: ValueKey('type-${_selectedType?.name ?? 'all'}'),
            value: _selectedType,
            label: l10n.transactionType,
            hintText: l10n.allTypes,
            prefixIcon: const Icon(Icons.swap_horiz_rounded),
            items: [
              DropdownMenuItem<TransactionEntryType?>(
                value: null,
                child: Text(l10n.allTypes),
              ),
              DropdownMenuItem<TransactionEntryType?>(
                value: TransactionEntryType.credit,
                child: Text(l10n.credit),
              ),
              DropdownMenuItem<TransactionEntryType?>(
                value: TransactionEntryType.debit,
                child: Text(l10n.debit),
              ),
            ],
            onChanged: (value) => setState(() => _selectedType = value),
          ),
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

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.transaction, required this.locale});

  final TransactionRecord transaction;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    return TransactionReportCard(
      typeLabel: _transactionTypeLabel(context, transaction.type),
      amount: formatCurrency(transaction.amount),
      walletName: transaction.walletName,
      branchName: transaction.branchName ?? l10n.notAvailable,
      createdByUsername: transaction.createdByUsername ?? l10n.notAvailable,
      occurredAt: AppDateFormatter.full(
        (transaction.occurredAt ?? transaction.date).toLocal(),
        locale: locale,
      ),
      description: transaction.note,
      isCredit: transaction.type == TransactionEntryType.credit,
    );
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

String _transactionTypeLabel(BuildContext context, TransactionEntryType type) {
  final l10n = appL10n(context);
  return switch (type) {
    TransactionEntryType.credit => l10n.credit,
    TransactionEntryType.debit => l10n.debit,
    TransactionEntryType.unknown => l10n.unknown,
  };
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
