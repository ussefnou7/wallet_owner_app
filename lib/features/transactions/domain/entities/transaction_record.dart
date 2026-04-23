import 'package:equatable/equatable.dart';

import 'transaction_draft.dart';

enum TransactionRecordStatus { recorded, pendingReview }

class TransactionRecord extends Equatable {
  const TransactionRecord({
    required this.id,
    this.tenantId,
    required this.walletId,
    required this.walletName,
    this.externalTransactionId,
    required this.type,
    required this.amount,
    this.percent = 0,
    this.phoneNumber,
    this.cash = false,
    required this.date,
    this.occurredAt,
    this.createdAt,
    this.updatedAt,
    required this.createdBy,
    required this.status,
    this.note,
  });

  final String id;
  final String? tenantId;
  final String walletId;
  final String walletName;
  final String? externalTransactionId;
  final TransactionEntryType type;
  final double amount;
  final double percent;
  final String? phoneNumber;
  final bool cash;
  final DateTime date;
  final DateTime? occurredAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String createdBy;
  final TransactionRecordStatus status;
  final String? note;

  @override
  List<Object?> get props => [
    id,
    tenantId,
    walletId,
    walletName,
    externalTransactionId,
    type,
    amount,
    percent,
    phoneNumber,
    cash,
    date,
    occurredAt,
    createdAt,
    updatedAt,
    createdBy,
    status,
    note,
  ];
}
