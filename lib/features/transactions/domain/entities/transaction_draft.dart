import 'package:equatable/equatable.dart';

enum TransactionEntryType { credit, debit, unknown }

class TransactionDraft extends Equatable {
  const TransactionDraft({
    required this.walletId,
    required this.type,
    required this.amount,
    required this.percent,
    required this.externalTransactionId,
    required this.occurredAt,
    required this.phoneNumber,
    required this.cash,
    this.description,
  });

  final String walletId;
  final TransactionEntryType type;
  final double amount;
  final double percent;
  final String externalTransactionId;
  final DateTime occurredAt;
  final String phoneNumber;
  final bool cash;
  final String? description;

  @override
  List<Object?> get props => [
    walletId,
    type,
    amount,
    percent,
    externalTransactionId,
    occurredAt,
    phoneNumber,
    cash,
    description,
  ];
}
