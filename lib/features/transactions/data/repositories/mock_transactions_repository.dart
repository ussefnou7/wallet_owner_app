import '../../../../core/network/models/paged_response.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/entities/transaction_submission_result.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../models/transaction_record_model.dart';

class MockTransactionsRepository implements TransactionsRepository {
  final List<TransactionRecord> _transactions = [
    TransactionRecordModel(
      id: 'TXN-240101',
      walletId: 'wallet-1',
      walletName: 'Main Wallet',
      type: TransactionEntryType.credit,
      amount: 1250,
      date: DateTime(2026, 4, 18, 9, 30),
      createdBy: 'owner-1',
      createdByUsername: 'Owner User',
      status: TransactionRecordStatus.recorded,
      note: 'Walk-in deposit adjustment',
    ),
    TransactionRecordModel(
      id: 'TXN-240102',
      walletId: 'wallet-2',
      walletName: 'Branch Wallet',
      type: TransactionEntryType.debit,
      amount: 420,
      date: DateTime(2026, 4, 17, 17, 15),
      createdBy: 'owner-1',
      createdByUsername: 'Owner User',
      status: TransactionRecordStatus.recorded,
      note: 'Courier settlement payout',
    ),
    TransactionRecordModel(
      id: 'TXN-240103',
      walletId: 'wallet-4',
      walletName: 'VIP Customer Wallet',
      type: TransactionEntryType.credit,
      amount: 780,
      date: DateTime(2026, 4, 17, 13, 05),
      createdBy: 'user-2',
      createdByUsername: 'Mariam Hassan',
      status: TransactionRecordStatus.pendingReview,
      note: 'VIP client transfer confirmation',
    ),
    TransactionRecordModel(
      id: 'TXN-240104',
      walletId: 'wallet-3',
      walletName: 'Delivery Wallet',
      type: TransactionEntryType.debit,
      amount: 160,
      date: DateTime(2026, 4, 16, 11, 40),
      createdBy: 'owner-1',
      createdByUsername: 'Owner User',
      status: TransactionRecordStatus.recorded,
      note: 'Delivery reimbursement',
    ),
  ];

  @override
  Future<PagedResponse<TransactionRecord>> getTransactions({
    required TransactionsFilterState filter,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final transactions = _transactions.where((transaction) {
      if (filter.walletId != null && transaction.walletId != filter.walletId) {
        return false;
      }
      if (filter.type != null &&
          filter.type != TransactionEntryType.unknown &&
          transaction.type != filter.type) {
        return false;
      }
      if (filter.createdBy != null &&
          filter.createdBy!.isNotEmpty &&
          transaction.createdBy != filter.createdBy) {
        return false;
      }
      if (filter.dateFrom != null && transaction.date.isBefore(filter.dateFrom!)) {
        return false;
      }
      if (filter.dateTo != null && transaction.date.isAfter(filter.dateTo!)) {
        return false;
      }
      return true;
    }).toList();
    transactions.sort((a, b) => b.date.compareTo(a.date));
    final start = filter.page * filter.size;
    final end = (start + filter.size).clamp(0, transactions.length);
    final content = start >= transactions.length
        ? const <TransactionRecord>[]
        : transactions.sublist(start, end);
    final totalElements = transactions.length;
    final totalPages = totalElements == 0
        ? 0
        : (totalElements / filter.size).ceil();
    final hasNext = end < totalElements;

    return PagedResponse<TransactionRecord>(
      content: content,
      page: filter.page,
      size: filter.size,
      totalElements: totalElements,
      totalPages: totalPages,
      last: !hasNext,
      hasNext: hasNext,
    );
  }

  @override
  Future<TransactionRecord> getTransactionById(String transactionId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _transactions.firstWhere(
      (transaction) => transaction.id == transactionId,
    );
  }

  @override
  Future<TransactionSubmissionResult> submitTransaction(
    TransactionDraft draft,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final createdAt = DateTime.now();
    final referenceId = 'TXN-${createdAt.millisecondsSinceEpoch}';
    _transactions.insert(
      0,
      TransactionRecordModel(
        id: referenceId,
        walletId: draft.walletId,
        walletName: _walletNameFor(draft.walletId),
        externalTransactionId: draft.externalTransactionId,
        type: draft.type,
        amount: draft.amount,
        percent: draft.percent,
        phoneNumber: draft.phoneNumber,
        cash: draft.cash,
        date: draft.occurredAt,
        occurredAt: draft.occurredAt,
        createdAt: createdAt,
        createdBy: 'owner-1',
        createdByUsername: 'Owner User',
        status: TransactionRecordStatus.recorded,
        note: draft.description?.trim().isEmpty ?? true
            ? null
            : draft.description!.trim(),
      ),
    );

    return TransactionSubmissionResult(
      referenceId: referenceId,
      createdAt: createdAt,
    );
  }

  String _walletNameFor(String walletId) {
    switch (walletId) {
      case 'wallet-1':
        return 'Main Wallet';
      case 'wallet-2':
        return 'Branch Wallet';
      case 'wallet-3':
        return 'Delivery Wallet';
      case 'wallet-4':
        return 'VIP Customer Wallet';
      default:
        return 'Wallet';
    }
  }
}
