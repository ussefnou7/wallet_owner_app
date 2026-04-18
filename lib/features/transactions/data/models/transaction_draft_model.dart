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
      'type': type.name,
      'amount': amount,
      'note': note,
      'date': date.toIso8601String(),
      'createdBy': createdBy,
    };
  }
}
