import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/models/paged_response.dart';
import '../entities/transaction_draft.dart';
import '../entities/transactions_filter_state.dart';
import '../entities/transaction_record.dart';
import '../entities/transaction_submission_result.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  throw UnimplementedError(
    'transactionsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class TransactionsRepository {
  Future<PagedResponse<TransactionRecord>> getTransactions({
    required TransactionsFilterState filter,
  });

  Future<TransactionRecord> getTransactionById(String transactionId);

  Future<TransactionSubmissionResult> submitTransaction(TransactionDraft draft);
}
