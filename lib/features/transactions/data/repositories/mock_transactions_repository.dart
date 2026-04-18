import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/entities/transaction_submission_result.dart';
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
      createdBy: 'Owner User',
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
      createdBy: 'Owner User',
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
      createdBy: 'Mariam Hassan',
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
      createdBy: 'Owner User',
      status: TransactionRecordStatus.recorded,
      note: 'Delivery reimbursement',
    ),
  ];

  @override
  Future<List<TransactionRecord>> getTransactions() async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    final transactions = [..._transactions];
    transactions.sort((a, b) => b.date.compareTo(a.date));
    return transactions;
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
        type: draft.type,
        amount: draft.amount,
        date: draft.date,
        createdBy: draft.createdBy,
        status: TransactionRecordStatus.recorded,
        note: draft.note.isEmpty ? null : draft.note,
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
