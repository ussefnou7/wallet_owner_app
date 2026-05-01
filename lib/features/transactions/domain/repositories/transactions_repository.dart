import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/models/paged_response.dart';
import '../entities/transaction_draft.dart';
import '../entities/transaction_record.dart';
import '../entities/transaction_submission_result.dart';

final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  throw UnimplementedError(
    'transactionsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class TransactionsRepository {
  Future<PagedResponse<TransactionRecord>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 0,
    int size = 20,
  });

  Future<TransactionRecord> getTransactionById(String transactionId);

  Future<TransactionSubmissionResult> submitTransaction(TransactionDraft draft);
}
