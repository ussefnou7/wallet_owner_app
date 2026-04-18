import 'package:equatable/equatable.dart';

enum TransactionEntryType { credit, debit }

class TransactionDraft extends Equatable {
  const TransactionDraft({
    required this.walletId,
    required this.type,
    required this.amount,
    required this.note,
    required this.date,
    required this.createdBy,
  });

  final String walletId;
  final TransactionEntryType type;
  final double amount;
  final String note;
  final DateTime date;
  final String createdBy;

  @override
  List<Object?> get props => [walletId, type, amount, note, date, createdBy];
}
