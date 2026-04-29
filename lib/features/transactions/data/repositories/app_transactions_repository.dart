import '../../../../core/network/api_result.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/entities/transaction_submission_result.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../models/transaction_draft_model.dart';
import '../services/transactions_remote_data_source.dart';

class AppTransactionsRepository implements TransactionsRepository {
  AppTransactionsRepository({
    required TransactionsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final TransactionsRemoteDataSource _remoteDataSource;

  @override
  Future<List<TransactionRecord>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return _remoteDataSource
        .getTransactions(
          walletId: walletId,
          type: type,
          dateFrom: dateFrom,
          dateTo: dateTo,
        )
        .then(_unwrap);
  }

  @override
  Future<TransactionRecord> getTransactionById(String transactionId) {
    return _remoteDataSource.getTransactionById(transactionId).then(_unwrap);
  }

  @override
  Future<TransactionSubmissionResult> submitTransaction(
    TransactionDraft draft,
  ) async {
    final request = TransactionDraftModel(
      walletId: draft.walletId,
      type: draft.type,
      amount: draft.amount,
      percent: draft.percent,
      externalTransactionId: draft.externalTransactionId,
      occurredAt: draft.occurredAt,
      phoneNumber: draft.phoneNumber,
      cash: draft.cash,
      description: draft.description,
    );
    final transaction = await _remoteDataSource
        .createTransaction(request)
        .then(_unwrap);

    return TransactionSubmissionResult(
      referenceId: transaction.externalTransactionId ?? transaction.id,
      createdAt: transaction.createdAt ?? DateTime.now(),
    );
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
