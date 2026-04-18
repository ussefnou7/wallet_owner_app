import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../transactions/domain/entities/recent_transaction.dart';
import '../../domain/entities/dashboard_summary.dart';

final dashboardSummaryProvider = Provider<DashboardSummary>((ref) {
  return const DashboardSummary(
    totalProfit: 182450,
    activeWallets: 24,
    totalTransactions: 1382,
    totalCredit: 924300,
    totalDebit: 741850,
    recentTransactions: [
      RecentTransaction(
        id: 'TXN-1001',
        walletName: 'Main Cash Wallet',
        amount: 1200,
        type: TransactionType.credit,
      ),
      RecentTransaction(
        id: 'TXN-1002',
        walletName: 'Branch Wallet 02',
        amount: 420,
        type: TransactionType.debit,
      ),
      RecentTransaction(
        id: 'TXN-1003',
        walletName: 'VIP Customer Wallet',
        amount: 780,
        type: TransactionType.credit,
      ),
    ],
  );
});
