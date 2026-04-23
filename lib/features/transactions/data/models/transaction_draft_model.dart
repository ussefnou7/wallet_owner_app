import '../../domain/entities/transaction_draft.dart';

class TransactionDraftModel extends TransactionDraft {
  const TransactionDraftModel({
    required super.walletId,
    required super.type,
    required super.amount,
    required super.note,
    required super.date,
    required super.createdBy,
  });

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'type': switch (type) {
        TransactionEntryType.credit => 'CREDIT',
        TransactionEntryType.debit => 'DEBIT',
        TransactionEntryType.unknown => 'UNKNOWN',
      },
      'amount': amount,
      // TODO: Confirm transaction fee semantics with the backend. The current
      // owner UI has no fee input, while the create request example sends
      // `fee` and the response returns `percent`.
      'fee': 0,
      'description': note,
    };
  }
}
