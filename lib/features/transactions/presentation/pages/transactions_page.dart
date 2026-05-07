import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
import '../../../../core/widgets/icon_action_button.dart';
import '../../../auth/domain/entities/session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../users/domain/entities/app_user.dart';
import '../../../users/presentation/controllers/users_controller.dart';
import '../../../wallets/domain/entities/wallet.dart';
import '../../../wallets/presentation/controllers/wallets_controller.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/transaction_record_tile.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  late final TextEditingController _searchController;
  int _buildCount = 0;

  bool _filtersExpanded = false;
  String? _draftWalletId;
  String? _draftCreatedBy;
  DateTime? _draftDateFrom;
  DateTime? _draftDateTo;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(transactionsSearchQueryProvider),
    );
    _syncDraftFromApplied(ref.read(transactionsControllerProvider).filter);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionsState = ref.watch(transactionsControllerProvider);
    final filteredTransactions = ref.watch(filteredTransactionsProvider);
    final searchQuery = ref.watch(transactionsSearchQueryProvider);
    final l10n = appL10n(context);
    final appliedFilter = transactionsState.filter;
    final session = _readSession();
    final canFilterByCreator = session?.isOwner == true;
    final shouldLoadFilterData =
        _filtersExpanded || appliedFilter.hasActiveFilters;
    final walletsState = _watchWalletsState(shouldLoadFilterData);
    final usersAsync = _watchUsersState(
      shouldLoadFilterData && canFilterByCreator,
    );
    final locale = MaterialLocalizations.of(context);
    final wallets = walletsState.data;
    final List<AppUser> users = usersAsync.maybeWhen(
      data: (data) => data,
      orElse: () => const <AppUser>[],
    );
    _buildCount += 1;
    developer.log(
      'TransactionsPage build=$_buildCount '
      'items=${transactionsState.transactions.length} '
      'hasNext=${transactionsState.hasNext} '
      'isInitialLoading=${transactionsState.isInitialLoading} '
      'isLoadingMore=${transactionsState.isLoadingMore}',
      name: 'transactions_page',
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppSectionHeader(
          title: l10n.transactionsHistory,
          subtitle: l10n.transactionsHistorySubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: AppTextField(
                controller: _searchController,
                label: l10n.searchTransactions,
                hintText: l10n.searchTransactionsHint,
                prefixIcon: const Icon(Icons.search_rounded),
                onChanged: ref
                    .read(transactionsControllerProvider.notifier)
                    .updateQuery,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconActionButton(
              icon: Icons.refresh_rounded,
              tooltip: l10n.refresh,
              onPressed: transactionsState.isInitialLoading
                  ? null
                  : () => ref
                        .read(transactionsControllerProvider.notifier)
                        .refresh(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        FilterChipRow<TransactionFilterType>(
          selectedValue: transactionsState.activeFilterType,
          onSelected: ref
              .read(transactionsControllerProvider.notifier)
              .updateFilterType,
          options: [
            FilterChipOption(value: TransactionFilterType.all, label: l10n.all),
            FilterChipOption(
              value: TransactionFilterType.credit,
              label: l10n.credit,
            ),
            FilterChipOption(
              value: TransactionFilterType.debit,
              label: l10n.debit,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        _ExpandableFiltersCard(
          expanded: _filtersExpanded,
          activeCount: appliedFilter.activeFiltersCount,
          onToggle: () {
            setState(() {
              _filtersExpanded = !_filtersExpanded;
              if (_filtersExpanded) {
                _syncDraftFromApplied(appliedFilter);
              }
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DateRangeFields(
                dateFrom: _draftDateFrom,
                dateTo: _draftDateTo,
                onSelectDateFrom: () => _pickDate(
                  context,
                  initialDate: _draftDateFrom ?? DateTime.now(),
                  onSelected: (value) {
                    setState(() {
                      _draftDateFrom = _dateOnly(value);
                    });
                  },
                ),
                onSelectDateTo: () => _pickDate(
                  context,
                  initialDate: _draftDateTo ?? _draftDateFrom ?? DateTime.now(),
                  onSelected: (value) {
                    setState(() {
                      _draftDateTo = _dateOnly(value);
                    });
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              DropdownButtonFormField<String?>(
                key: ValueKey('wallet-filter-${_draftWalletId ?? 'all'}'),
                initialValue: _draftWalletId,
                decoration: InputDecoration(
                  labelText: l10n.wallet,
                  prefixIcon: const Icon(Icons.account_balance_wallet_outlined),
                ),
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l10n.all)),
                  for (final wallet in wallets)
                    DropdownMenuItem<String?>(
                      value: wallet.id,
                      child: Text(wallet.name, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: walletsState.isLoading
                    ? null
                    : (value) => setState(() => _draftWalletId = value),
                hint: Text(walletsState.isLoading ? l10n.loading : l10n.all),
              ),
              if (canFilterByCreator) ...[
                const SizedBox(height: AppSpacing.sm),
                DropdownButtonFormField<String?>(
                  key: ValueKey('creator-filter-${_draftCreatedBy ?? 'all'}'),
                  initialValue: _draftCreatedBy,
                  decoration: InputDecoration(
                    labelText: l10n.createdByUser,
                    prefixIcon: const Icon(Icons.person_outline_rounded),
                  ),
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(l10n.all),
                    ),
                    for (final user in users)
                      DropdownMenuItem<String?>(
                        value: user.id,
                        child: Text(
                          user.username,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: usersAsync.isLoading
                      ? null
                      : (value) => setState(() => _draftCreatedBy = value),
                  hint: Text(usersAsync.isLoading ? l10n.loading : l10n.all),
                ),
              ],
              const SizedBox(height: AppSpacing.md),
              _FilterActions(
                onClear: () async {
                  setState(() {
                    _syncDraftFromApplied(
                      appliedFilter.clearAll(type: appliedFilter.type),
                    );
                  });
                  await ref
                      .read(transactionsControllerProvider.notifier)
                      .clearAllFilters();
                },
                onApply: () async {
                  await ref
                      .read(transactionsControllerProvider.notifier)
                      .applyFilters(_buildDraftFilter(appliedFilter));
                  if (!mounted) {
                    return;
                  }
                  setState(() => _filtersExpanded = false);
                },
              ),
            ],
          ),
        ),
        if (appliedFilter.hasActiveFilters) ...[
          const SizedBox(height: AppSpacing.sm),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                if (appliedFilter.walletId != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.sm,
                    ),
                    child: InputChip(
                      label: Text(
                        '${l10n.wallet}: ${_walletLabelFor(appliedFilter.walletId, wallets)}',
                      ),
                      onDeleted: () async {
                        setState(() => _draftWalletId = null);
                        await ref
                            .read(transactionsControllerProvider.notifier)
                            .clearWalletFilter();
                      },
                    ),
                  ),
                if (appliedFilter.dateFrom != null ||
                    appliedFilter.dateTo != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.sm,
                    ),
                    child: InputChip(
                      label: Text(_dateRangeLabel(locale, appliedFilter)),
                      onDeleted: () async {
                        setState(() {
                          _draftDateFrom = null;
                          _draftDateTo = null;
                        });
                        await ref
                            .read(transactionsControllerProvider.notifier)
                            .clearDateRangeFilter();
                      },
                    ),
                  ),
                if (canFilterByCreator && appliedFilter.createdBy != null)
                  InputChip(
                    label: Text(
                      '${l10n.createdByUser}: ${_userLabelFor(appliedFilter.createdBy, users)}',
                    ),
                    onDeleted: () async {
                      setState(() => _draftCreatedBy = null);
                      await ref
                          .read(transactionsControllerProvider.notifier)
                          .clearCreatedByFilter();
                    },
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: _TransactionsBody(
            isInitialLoading: transactionsState.isInitialLoading,
            errorMessage: transactionsState.errorMessage,
            transactions: filteredTransactions,
            hasNext: transactionsState.hasNext,
            isLoadingMore: transactionsState.isLoadingMore,
            loadMoreError: transactionsState.loadMoreError,
            searchQuery: searchQuery,
            onRefresh: () =>
                ref.read(transactionsControllerProvider.notifier).refresh(),
            onLoadMore: () =>
                ref.read(transactionsControllerProvider.notifier).loadMore(),
          ),
        ),
      ],
    );
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime initialDate,
    required ValueChanged<DateTime> onSelected,
  }) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5);
    final lastDate = DateTime(now.year + 5);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      onSelected(picked);
    }
  }

  TransactionsFilterState _buildDraftFilter(TransactionsFilterState applied) {
    var dateFrom = _draftDateFrom;
    var dateTo = _draftDateTo;
    if (dateFrom != null && dateTo != null && dateFrom.isAfter(dateTo)) {
      final normalizedFrom = dateTo;
      dateTo = dateFrom;
      dateFrom = normalizedFrom;
    }

    return applied.copyWith(
      walletId: _draftWalletId,
      dateFrom: dateFrom,
      dateTo: dateTo,
      createdBy: _draftCreatedBy,
      page: 0,
      clearWalletId: _draftWalletId == null,
      clearDateFrom: dateFrom == null,
      clearDateTo: dateTo == null,
      clearCreatedBy: _draftCreatedBy == null,
    );
  }

  void _syncDraftFromApplied(TransactionsFilterState filter) {
    _draftWalletId = filter.walletId;
    _draftCreatedBy = filter.createdBy;
    _draftDateFrom = filter.dateFrom;
    _draftDateTo = filter.dateTo;
  }

  String _walletLabelFor(String? walletId, List<Wallet> wallets) {
    if (walletId == null) {
      return '';
    }
    for (final wallet in wallets) {
      if (wallet.id == walletId) {
        return wallet.name;
      }
    }
    return walletId;
  }

  String _userLabelFor(String? userId, List<AppUser> users) {
    if (userId == null) {
      return '';
    }
    for (final user in users) {
      if (user.id == userId) {
        return user.username;
      }
    }
    return userId;
  }

  String _dateRangeLabel(
    MaterialLocalizations localizations,
    TransactionsFilterState filter,
  ) {
    final from = filter.dateFrom == null
        ? null
        : localizations.formatMediumDate(filter.dateFrom!);
    final to = filter.dateTo == null
        ? null
        : localizations.formatMediumDate(filter.dateTo!);

    if (from != null && to != null) {
      return '$from - $to';
    }

    return from ?? to ?? '';
  }

  DateTime _dateOnly(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  Session? _readSession() {
    try {
      return ref.read(authControllerProvider).session;
    } catch (_) {
      return null;
    }
  }

  WalletListState _watchWalletsState(bool enabled) {
    if (!enabled) {
      return const WalletListState();
    }

    try {
      return ref.watch(walletsControllerProvider);
    } catch (_) {
      return const WalletListState();
    }
  }

  AsyncValue<List<AppUser>> _watchUsersState(bool enabled) {
    if (!enabled) {
      return const AsyncValue.data(<AppUser>[]);
    }

    try {
      return ref.watch(usersControllerProvider);
    } catch (_) {
      return const AsyncValue.data(<AppUser>[]);
    }
  }
}

class _ExpandableFiltersCard extends StatelessWidget {
  const _ExpandableFiltersCard({
    required this.expanded,
    required this.activeCount,
    required this.onToggle,
    required this.child,
  });

  final bool expanded;
  final int activeCount;
  final VoidCallback onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadii.lg),
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    l10n.filters,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (activeCount > 0) ...[
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primarySoft,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '$activeCount',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: child,
            ),
            crossFadeState: expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
          ),
        ],
      ),
    );
  }
}

class _FilterActions extends StatelessWidget {
  const _FilterActions({required this.onClear, required this.onApply});

  final Future<void> Function() onClear;
  final Future<void> Function() onApply;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final stacked = constraints.maxWidth < 420;
        if (stacked) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton(
                onPressed: onClear,
                child: Text(l10n.clearFilters),
              ),
              const SizedBox(height: AppSpacing.sm),
              FilledButton(onPressed: onApply, child: Text(l10n.applyFilters)),
            ],
          );
        }

        return Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            SizedBox(
              width: 160,
              child: OutlinedButton(
                onPressed: onClear,
                child: Text(l10n.clearFilters),
              ),
            ),
            SizedBox(
              width: 160,
              child: FilledButton(
                onPressed: onApply,
                child: Text(l10n.applyFilters),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DateRangeFields extends StatelessWidget {
  const _DateRangeFields({
    required this.dateFrom,
    required this.dateTo,
    required this.onSelectDateFrom,
    required this.onSelectDateTo,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final VoidCallback onSelectDateFrom;
  final VoidCallback onSelectDateTo;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final localizations = MaterialLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 520) {
          return Row(
            children: [
              Expanded(
                child: _DatePickerField(
                  label: l10n.fromDate,
                  value: dateFrom == null
                      ? null
                      : localizations.formatMediumDate(dateFrom!),
                  hintText: l10n.fromDate,
                  onTap: onSelectDateFrom,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _DatePickerField(
                  label: l10n.toDate,
                  value: dateTo == null
                      ? null
                      : localizations.formatMediumDate(dateTo!),
                  hintText: l10n.toDate,
                  onTap: onSelectDateTo,
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _DatePickerField(
              label: l10n.fromDate,
              value: dateFrom == null
                  ? null
                  : localizations.formatMediumDate(dateFrom!),
              hintText: l10n.fromDate,
              onTap: onSelectDateFrom,
            ),
            const SizedBox(height: AppSpacing.sm),
            _DatePickerField(
              label: l10n.toDate,
              value: dateTo == null
                  ? null
                  : localizations.formatMediumDate(dateTo!),
              hintText: l10n.toDate,
              onTap: onSelectDateTo,
            ),
          ],
        );
      },
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.hintText,
    required this.onTap,
    this.value,
  });

  final String label;
  final String hintText;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.md),
      onTap: onTap,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          prefixIcon: const Icon(Icons.calendar_today_rounded),
        ),
        child: Text(
          hasValue ? value! : hintText,
          style: hasValue
              ? null
              : Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
        ),
      ),
    );
  }
}

class _TransactionsLoadMoreSection extends StatelessWidget {
  const _TransactionsLoadMoreSection({
    required this.hasNext,
    required this.isLoadingMore,
    required this.error,
    required this.onPressed,
  });

  final bool hasNext;
  final bool isLoadingMore;
  final Object? error;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    if (!hasNext && error == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (error != null) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                l10n.loadMoreTransactionsFailed,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
          if (hasNext)
            FilledButton.tonal(
              onPressed: isLoadingMore ? null : onPressed,
              child: isLoadingMore
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(l10n.loadingMoreTransactions),
                      ],
                    )
                  : Text(l10n.loadMoreTransactions),
            ),
        ],
      ),
    );
  }
}

class _TransactionsBody extends StatelessWidget {
  const _TransactionsBody({
    required this.isInitialLoading,
    required this.errorMessage,
    required this.transactions,
    required this.hasNext,
    required this.isLoadingMore,
    required this.loadMoreError,
    required this.searchQuery,
    required this.onRefresh,
    required this.onLoadMore,
  });

  final bool isInitialLoading;
  final Object? errorMessage;
  final List<TransactionRecord> transactions;
  final bool hasNext;
  final bool isLoadingMore;
  final Object? loadMoreError;
  final String searchQuery;
  final Future<void> Function() onRefresh;
  final VoidCallback onLoadMore;

  @override
  Widget build(BuildContext context) {
    final l10n = appL10n(context);
    final bottomPadding =
        MediaQuery.paddingOf(context).bottom +
        AppDimensions.floatingBottomNavReservedHeight;

    if (isInitialLoading) {
      return _ScrollableTransactionsState(
        bottomPadding: bottomPadding,
        child: AppLoadingView(message: l10n.loadingTransactions),
      );
    }

    if (errorMessage != null && transactions.isEmpty) {
      return _ScrollableTransactionsState(
        bottomPadding: bottomPadding,
        child: AppErrorState(
          message: l10n.unableToLoadTransactions,
          onRetry: onRefresh,
        ),
      );
    }

    if (transactions.isEmpty) {
      return _ScrollableTransactionsState(
        bottomPadding: bottomPadding,
        child: AppEmptyState(
          title: searchQuery.trim().isEmpty
              ? l10n.noTransactionsAvailable
              : l10n.noMatchingTransactions,
          message: searchQuery.trim().isEmpty
              ? l10n.transactionsEmptyMessage
              : l10n.transactionsSearchEmptyMessage,
          icon: Icons.receipt_long_outlined,
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.only(bottom: bottomPadding),
        itemCount: transactions.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 6),
        itemBuilder: (context, index) {
          if (index == transactions.length) {
            return _TransactionsLoadMoreSection(
              hasNext: hasNext,
              isLoadingMore: isLoadingMore,
              error: loadMoreError,
              onPressed: onLoadMore,
            );
          }

          return TransactionRecordTile(transaction: transactions[index]);
        },
      ),
    );
  }
}

class _ScrollableTransactionsState extends StatelessWidget {
  const _ScrollableTransactionsState({
    required this.child,
    required this.bottomPadding,
  });

  final Widget child;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - bottomPadding).clamp(
                0,
                double.infinity,
              ),
            ),
            child: Center(child: child),
          ),
        );
      },
    );
  }
}
