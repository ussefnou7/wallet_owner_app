import 'package:equatable/equatable.dart';

class DashboardTransactionSummary extends Equatable {
  const DashboardTransactionSummary({
    required this.totalCredits,
    required this.totalDebits,
    required this.netAmount,
    required this.transactionCount,
  });

  final double totalCredits;
  final double totalDebits;
  final double netAmount;
  final int transactionCount;

  @override
  List<Object?> get props => [
    totalCredits,
    totalDebits,
    netAmount,
    transactionCount,
  ];
}
