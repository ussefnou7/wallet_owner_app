import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/localization/app_l10n.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_error_state.dart';
import '../../../../core/widgets/app_loading_view.dart';
import '../../../../core/widgets/app_section_header.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/filter_chip_row.dart';
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
            IconButton.outlined(
              tooltip: l10n.refreshTransactions,
              onPressed: transactionsState.isLoading
                  ? null
                  : () => ref
                        .read(transactionsControllerProvider.notifier)
                        .reload(),
              icon: const Icon(Icons.refresh_rounded),
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
          child: transactionsState.when(
            loading: () => AppLoadingView(message: l10n.loadingTransactions),
            error: (error, stackTrace) => AppErrorState(
              message: l10n.unableToLoadTransactions,
              onRetry: () =>
                  ref.read(transactionsControllerProvider.notifier).reload(),
            ),
            data: (_) {
              if (filteredTransactions.isEmpty) {
                return AppEmptyState(
                  title: searchQuery.trim().isEmpty
                      ? l10n.noTransactionsAvailable
                      : l10n.noMatchingTransactions,
                  message: searchQuery.trim().isEmpty
                      ? l10n.transactionsEmptyMessage
                      : l10n.transactionsSearchEmptyMessage,
                  icon: Icons.receipt_long_outlined,
                );
              }

              return ListView.separated(
                itemCount: filteredTransactions.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  return TransactionRecordTile(
                    transaction: filteredTransactions[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
