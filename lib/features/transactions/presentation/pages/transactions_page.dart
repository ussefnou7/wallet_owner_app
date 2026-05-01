import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
import '../../../../core/widgets/icon_action_button.dart';
import '../controllers/transactions_controller.dart';
import '../widgets/transaction_record_tile.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(
      text: ref.read(transactionsSearchQueryProvider),
    );
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
    final filter = ref.watch(transactionsFilterProvider);
    final searchQuery = ref.watch(transactionsSearchQueryProvider);
    final l10n = appL10n(context);
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
                        .reload(),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        FilterChipRow<TransactionFilterType>(
          selectedValue: filter,
          onSelected: ref
              .read(transactionsControllerProvider.notifier)
              .updateFilter,
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
        Expanded(
          child: transactionsState.isInitialLoading
              ? AppLoadingView(message: l10n.loadingTransactions)
              : transactionsState.errorMessage != null &&
                    transactionsState.transactions.isEmpty
              ? AppErrorState(
                  message: l10n.unableToLoadTransactions,
                  onRetry: () => ref
                      .read(transactionsControllerProvider.notifier)
                      .reload(),
                )
              : filteredTransactions.isEmpty
              ? AppEmptyState(
                  title: searchQuery.trim().isEmpty
                      ? l10n.noTransactionsAvailable
                      : l10n.noMatchingTransactions,
                  message: searchQuery.trim().isEmpty
                      ? l10n.transactionsEmptyMessage
                      : l10n.transactionsSearchEmptyMessage,
                  icon: Icons.receipt_long_outlined,
                )
              : RefreshIndicator(
                  onRefresh: () => ref
                      .read(transactionsControllerProvider.notifier)
                      .refresh(),
                  child: ListView.separated(
                    padding: EdgeInsets.only(
                      bottom:
                          bottomInset +
                          AppDimensions.floatingBottomNavContentPadding,
                    ),
                    itemCount: filteredTransactions.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 6),
                    itemBuilder: (context, index) {
                      if (index == filteredTransactions.length) {
                        return _TransactionsLoadMoreSection(
                          hasNext: transactionsState.hasNext,
                          isLoadingMore: transactionsState.isLoadingMore,
                          error: transactionsState.loadMoreError,
                          onPressed: () => ref
                              .read(transactionsControllerProvider.notifier)
                              .loadMore(),
                        );
                      }

                      return TransactionRecordTile(
                        transaction: filteredTransactions[index],
                      );
                    },
                  ),
                ),
        ),
      ],
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
