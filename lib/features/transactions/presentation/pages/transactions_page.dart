import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_spacing.dart';
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const AppSectionHeader(
          title: 'Transactions History',
          subtitle:
              'Search and review recorded credit and debit activity across wallets.',
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _searchController,
          label: 'Search transactions',
          hintText: 'Search by wallet, note, or created by',
          prefixIcon: const Icon(Icons.search_rounded),
          onChanged: ref
              .read(transactionsControllerProvider.notifier)
              .updateQuery,
        ),
        const SizedBox(height: AppSpacing.md),
        FilterChipRow<TransactionFilterType>(
          selectedValue: filter,
          onSelected: ref
              .read(transactionsControllerProvider.notifier)
              .updateFilter,
          options: const [
            FilterChipOption(value: TransactionFilterType.all, label: 'All'),
            FilterChipOption(
              value: TransactionFilterType.credit,
              label: 'Credit',
            ),
            FilterChipOption(
              value: TransactionFilterType.debit,
              label: 'Debit',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: transactionsState.when(
            loading: () =>
                const AppLoadingView(message: 'Loading transactions...'),
            error: (error, stackTrace) => AppErrorState(
              message: 'Unable to load transactions right now.',
              onRetry: () =>
                  ref.read(transactionsControllerProvider.notifier).reload(),
            ),
            data: (_) {
              if (filteredTransactions.isEmpty) {
                return AppEmptyState(
                  title: searchQuery.trim().isEmpty
                      ? 'No transactions available'
                      : 'No matching transactions',
                  message: searchQuery.trim().isEmpty
                      ? 'Recorded transactions will appear here.'
                      : 'Try a different search or filter combination.',
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
