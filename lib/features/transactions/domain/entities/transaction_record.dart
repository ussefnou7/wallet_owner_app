import 'package:equatable/equatable.dart';

import 'transaction_draft.dart';

enum TransactionRecordStatus { recorded, pendingReview }

class TransactionRecord extends Equatable {
  const TransactionRecord({
    required this.id,
    required this.walletId,
    required this.walletName,
    required this.type,
    required this.amount,
    required this.date,
    required this.createdBy,
    required this.status,
    this.note,
  });

  final String id;
  final String walletId;
  final String walletName;
  final TransactionEntryType type;
  final double amount;
  final DateTime date;
  final String createdBy;
  final TransactionRecordStatus status;
  final String? note;

  @override
  List<Object?> get props => [
    id,
    walletId,
    walletName,
    type,
    amount,
    date,
    createdBy,
    status,
    note,
  ];
}
