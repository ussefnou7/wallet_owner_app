import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/recent_transaction.dart';

class DashboardSummary extends Equatable {
  const DashboardSummary({
    required this.totalProfit,
    required this.activeWallets,
    required this.totalTransactions,
    required this.totalCredit,
    required this.totalDebit,
    required this.recentTransactions,
  });

  final double totalProfit;
  final int activeWallets;
  final int totalTransactions;
  final double totalCredit;
  final double totalDebit;
  final List<RecentTransaction> recentTransactions;

  @override
  List<Object?> get props => [
    totalProfit,
    activeWallets,
    totalTransactions,
    totalCredit,
    totalDebit,
    recentTransactions,
  ];
}
