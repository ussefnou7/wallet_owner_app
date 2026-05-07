import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction_draft.dart';

enum BalanceScope { none, wallet, branch }

class TransactionSummaryResponse extends Equatable {
  const TransactionSummaryResponse({
    required this.summary,
    this.highestTransaction,
  });

  final TransactionSummarySummary summary;
  final TransactionSummaryHighestTransaction? highestTransaction;

  @override
  List<Object?> get props => [summary, highestTransaction];
}

class TransactionSummarySummary extends Equatable {
  const TransactionSummarySummary({
    required this.totalCredits,
    required this.totalDebits,
    required this.transactionCount,
    required this.creditCount,
    required this.debitCount,
    required this.balanceScope,
    this.balance,
  });

  final double totalCredits;
  final double totalDebits;
  final int transactionCount;
  final int creditCount;
  final int debitCount;
  final double? balance;
  final BalanceScope balanceScope;

  @override
  List<Object?> get props => [
    totalCredits,
    totalDebits,
    transactionCount,
    creditCount,
    debitCount,
    balance,
    balanceScope,
  ];
}

class TransactionSummaryHighestTransaction extends Equatable {
  const TransactionSummaryHighestTransaction({
    required this.id,
    required this.type,
    required this.amount,
    this.walletId,
    this.walletName,
    this.branchId,
    this.branchName,
    this.createdBy,
    this.createdByUsername,
    this.occurredAt,
    this.description,
  });

  final String id;
  final TransactionEntryType type;
  final double amount;
  final String? walletId;
  final String? walletName;
  final String? branchId;
  final String? branchName;
  final String? createdBy;
  final String? createdByUsername;
  final DateTime? occurredAt;
  final String? description;

  @override
  List<Object?> get props => [
    id,
    type,
    amount,
    walletId,
    walletName,
    branchId,
    branchName,
    createdBy,
    createdByUsername,
    occurredAt,
    description,
  ];
}
