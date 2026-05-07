import 'package:equatable/equatable.dart';

enum DashboardOverviewPeriod { daily, monthly, yearly }

extension DashboardOverviewPeriodX on DashboardOverviewPeriod {
  String get apiValue => switch (this) {
    DashboardOverviewPeriod.daily => 'DAILY',
    DashboardOverviewPeriod.monthly => 'MONTHLY',
    DashboardOverviewPeriod.yearly => 'YEARLY',
  };

  static DashboardOverviewPeriod fromApiValue(String? value) {
    return switch ((value ?? '').toUpperCase()) {
      'MONTHLY' => DashboardOverviewPeriod.monthly,
      'YEARLY' => DashboardOverviewPeriod.yearly,
      _ => DashboardOverviewPeriod.daily,
    };
  }
}

enum DashboardHealthStatus { good, warning, critical, unknown }

extension DashboardHealthStatusX on DashboardHealthStatus {
  static DashboardHealthStatus fromApiValue(String? value) {
    return switch ((value ?? '').toUpperCase()) {
      'GOOD' => DashboardHealthStatus.good,
      'WARNING' => DashboardHealthStatus.warning,
      'CRITICAL' => DashboardHealthStatus.critical,
      _ => DashboardHealthStatus.unknown,
    };
  }
}

enum DashboardAttentionSeverity { warning, critical, info, unknown }

extension DashboardAttentionSeverityX on DashboardAttentionSeverity {
  static DashboardAttentionSeverity fromApiValue(String? value) {
    return switch ((value ?? '').toUpperCase()) {
      'WARNING' => DashboardAttentionSeverity.warning,
      'CRITICAL' => DashboardAttentionSeverity.critical,
      'INFO' => DashboardAttentionSeverity.info,
      _ => DashboardAttentionSeverity.unknown,
    };
  }
}

class OwnerDashboardOverview extends Equatable {
  const OwnerDashboardOverview({
    required this.period,
    required this.profitSnapshot,
    required this.walletHealth,
  });

  factory OwnerDashboardOverview.empty({
    DashboardOverviewPeriod period = DashboardOverviewPeriod.daily,
  }) {
    return OwnerDashboardOverview(
      period: period,
      profitSnapshot: const DashboardProfitSnapshot(
        totalProfit: 0,
        totalCollectedProfit: 0,
        totalUncollectedProfit: 0,
        totalTransactions: 0,
        totalTransactionVolume: 0,
      ),
      walletHealth: const DashboardWalletHealth(
        totalWallets: 0,
        activeWallets: 0,
        inactiveWallets: 0,
        activeWalletsBalance: 0,
        nearDailyLimitCount: 0,
        nearMonthlyLimitCount: 0,
        limitReachedCount: 0,
        walletsNeedAttentionCount: 0,
        healthStatus: DashboardHealthStatus.unknown,
        attentionItems: <DashboardWalletAttentionItem>[],
      ),
    );
  }

  final DashboardOverviewPeriod period;
  final DashboardProfitSnapshot profitSnapshot;
  final DashboardWalletHealth walletHealth;

  @override
  List<Object?> get props => [period, profitSnapshot, walletHealth];
}

class DashboardProfitSnapshot extends Equatable {
  const DashboardProfitSnapshot({
    required this.totalProfit,
    required this.totalCollectedProfit,
    required this.totalUncollectedProfit,
    required this.totalTransactions,
    required this.totalTransactionVolume,
  });

  final double totalProfit;
  final double totalCollectedProfit;
  final double totalUncollectedProfit;
  final int totalTransactions;
  final double totalTransactionVolume;

  @override
  List<Object?> get props => [
    totalProfit,
    totalCollectedProfit,
    totalUncollectedProfit,
    totalTransactions,
    totalTransactionVolume,
  ];
}

class DashboardWalletHealth extends Equatable {
  const DashboardWalletHealth({
    required this.totalWallets,
    required this.activeWallets,
    required this.inactiveWallets,
    required this.activeWalletsBalance,
    required this.nearDailyLimitCount,
    required this.nearMonthlyLimitCount,
    required this.limitReachedCount,
    required this.walletsNeedAttentionCount,
    required this.healthStatus,
    required this.attentionItems,
  });

  final int totalWallets;
  final int activeWallets;
  final int inactiveWallets;
  final double activeWalletsBalance;
  final int nearDailyLimitCount;
  final int nearMonthlyLimitCount;
  final int limitReachedCount;
  final int walletsNeedAttentionCount;
  final DashboardHealthStatus healthStatus;
  final List<DashboardWalletAttentionItem> attentionItems;

  @override
  List<Object?> get props => [
    totalWallets,
    activeWallets,
    inactiveWallets,
    activeWalletsBalance,
    nearDailyLimitCount,
    nearMonthlyLimitCount,
    limitReachedCount,
    walletsNeedAttentionCount,
    healthStatus,
    attentionItems,
  ];
}

class DashboardWalletAttentionItem extends Equatable {
  const DashboardWalletAttentionItem({
    required this.walletId,
    required this.walletName,
    this.branchName,
    required this.type,
    required this.severity,
    required this.currentPercent,
    required this.message,
  });

  final String walletId;
  final String walletName;
  final String? branchName;
  final String type;
  final DashboardAttentionSeverity severity;
  final double currentPercent;
  final String message;

  @override
  List<Object?> get props => [
    walletId,
    walletName,
    branchName,
    type,
    severity,
    currentPercent,
    message,
  ];
}
