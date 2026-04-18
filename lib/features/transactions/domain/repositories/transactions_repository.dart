import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/transaction_draft.dart';
import '../entities/transaction_record.dart';
import '../entities/transaction_submission_result.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  throw UnimplementedError(
    'transactionsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class TransactionsRepository {
  Future<List<TransactionRecord>> getTransactions();

  Future<TransactionSubmissionResult> submitTransaction(TransactionDraft draft);
}
