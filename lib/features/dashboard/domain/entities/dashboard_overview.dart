import 'package:equatable/equatable.dart';

enum DashboardMetricDisplayType { amount, count, percent, text, boolean }

class DashboardOverview extends Equatable {
  const DashboardOverview({
    required this.totalBalance,
    required this.activeWallets,
    required this.totalCredits,
    required this.totalDebits,
    required this.netAmount,
    required this.transactionCount,
    required this.metrics,
  });

  final double totalBalance;
  final int activeWallets;
  final double totalCredits;
  final double totalDebits;
  final double netAmount;
  final int transactionCount;
  final List<DashboardOverviewMetric> metrics;

  @override
  List<Object?> get props => [
    totalBalance,
    activeWallets,
    totalCredits,
    totalDebits,
    netAmount,
    transactionCount,
    metrics,
  ];
}

class DashboardOverviewMetric extends Equatable {
  const DashboardOverviewMetric({
    required this.key,
    required this.label,
    required this.value,
    required this.displayType,
  });

  final String key;
  final String label;
  final Object? value;
  final DashboardMetricDisplayType displayType;

  @override
  List<Object?> get props => [key, label, value, displayType];
}
