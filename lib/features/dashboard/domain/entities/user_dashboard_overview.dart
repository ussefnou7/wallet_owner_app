import 'package:equatable/equatable.dart';

import 'owner_dashboard_overview.dart';

class UserDashboardOverview extends Equatable {
  const UserDashboardOverview({
    required this.period,
    required this.myActivity,
    required this.branchWallets,
    required this.walletConsumptions,
  });

  factory UserDashboardOverview.empty({
    DashboardOverviewPeriod period = DashboardOverviewPeriod.daily,
  }) {
    return UserDashboardOverview(
      period: period,
      myActivity: const UserDashboardActivity(
        totalCredits: 0,
        totalDebits: 0,
        transactionsVolume: 0,
        transactionsCount: 0,
        totalProfit: 0,
      ),
      branchWallets: const UserDashboardBranchWallets(
        walletsCount: 0,
        totalBalance: 0,
        totalWalletProfit: 0,
        totalCashProfit: 0,
        totalProfit: 0,
        nearLimitWalletsCount: 0,
      ),
      walletConsumptions: const <UserDashboardWalletConsumption>[],
    );
  }

  final DashboardOverviewPeriod period;
  final UserDashboardActivity myActivity;
  final UserDashboardBranchWallets branchWallets;
  final List<UserDashboardWalletConsumption> walletConsumptions;

  @override
  List<Object?> get props => [
    period,
    myActivity,
    branchWallets,
    walletConsumptions,
  ];
}

class UserDashboardActivity extends Equatable {
  const UserDashboardActivity({
    required this.totalCredits,
    required this.totalDebits,
    required this.transactionsVolume,
    required this.transactionsCount,
    required this.totalProfit,
  });

  final double totalCredits;
  final double totalDebits;
  final double transactionsVolume;
  final int transactionsCount;
  final double totalProfit;

  @override
  List<Object?> get props => [
    totalCredits,
    totalDebits,
    transactionsVolume,
    transactionsCount,
    totalProfit,
  ];
}

class UserDashboardBranchWallets extends Equatable {
  const UserDashboardBranchWallets({
    required this.walletsCount,
    required this.totalBalance,
    required this.totalWalletProfit,
    required this.totalCashProfit,
    required this.totalProfit,
    required this.nearLimitWalletsCount,
  });

  final int walletsCount;
  final double totalBalance;
  final double totalWalletProfit;
  final double totalCashProfit;
  final double totalProfit;
  final int nearLimitWalletsCount;

  @override
  List<Object?> get props => [
    walletsCount,
    totalBalance,
    totalWalletProfit,
    totalCashProfit,
    totalProfit,
    nearLimitWalletsCount,
  ];
}

class UserDashboardWalletConsumption extends Equatable {
  const UserDashboardWalletConsumption({
    required this.walletId,
    required this.walletName,
    this.branchName,
    required this.dailyPercent,
    required this.monthlyPercent,
  });

  final String walletId;
  final String walletName;
  final String? branchName;
  final double dailyPercent;
  final double monthlyPercent;

  @override
  List<Object?> get props => [
    walletId,
    walletName,
    branchName,
    dailyPercent,
    monthlyPercent,
  ];
}
