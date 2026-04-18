import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/repositories/transactions_repository.dart';

enum TransactionFilterType { all, credit, debit }

final transactionsSearchQueryProvider = StateProvider<String>((ref) => '');
final transactionsFilterProvider = StateProvider<TransactionFilterType>(
  (ref) => TransactionFilterType.all,
);

final transactionsControllerProvider =
    AsyncNotifierProvider<TransactionsController, List<TransactionRecord>>(
      TransactionsController.new,
    );

final filteredTransactionsProvider = Provider<List<TransactionRecord>>((ref) {
  final transactionsAsync = ref.watch(transactionsControllerProvider);
  final query = ref.watch(transactionsSearchQueryProvider).trim().toLowerCase();
  final filter = ref.watch(transactionsFilterProvider);

  return transactionsAsync.maybeWhen(
    data: (transactions) {
      final filteredByType = switch (filter) {
        TransactionFilterType.all => transactions,
        TransactionFilterType.credit =>
          transactions
              .where(
                (transaction) =>
                    transaction.type == TransactionEntryType.credit,
              )
              .toList(),
        TransactionFilterType.debit =>
          transactions
              .where(
                (transaction) => transaction.type == TransactionEntryType.debit,
              )
              .toList(),
      };

      if (query.isEmpty) {
        return filteredByType;
      }

      return filteredByType.where((transaction) {
        return transaction.walletName.toLowerCase().contains(query) ||
            (transaction.note?.toLowerCase().contains(query) ?? false) ||
            transaction.createdBy.toLowerCase().contains(query);
      }).toList();
    },
    orElse: () => const [],
  );
});

class TransactionsController extends AsyncNotifier<List<TransactionRecord>> {
  @override
  Future<List<TransactionRecord>> build() async {
    final repository = ref.watch(transactionsRepositoryProvider);
    return repository.getTransactions();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(transactionsRepositoryProvider);
      return repository.getTransactions();
    });
  }

  void updateQuery(String value) {
    ref.read(transactionsSearchQueryProvider.notifier).state = value;
  }

  void updateFilter(TransactionFilterType value) {
    ref.read(transactionsFilterProvider.notifier).state = value;
  }
}
