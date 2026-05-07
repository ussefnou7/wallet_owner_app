import 'package:equatable/equatable.dart';

class ProfitSummaryResponse extends Equatable {
  const ProfitSummaryResponse({required this.summary});

  final ProfitSummarySummary summary;

  @override
  List<Object?> get props => [summary];
}

class ProfitSummarySummary extends Equatable {
  const ProfitSummarySummary({
    required this.totalProfits,
    required this.totalCollectedProfit,
    required this.totalUncollectedProfit,
    required this.totalBalance,
    required this.walletsWithCurrentProfit,
    required this.totalActiveWallets,
  });

  final double totalProfits;
  final double totalCollectedProfit;
  final double totalUncollectedProfit;
  final double totalBalance;
  final int walletsWithCurrentProfit;
  final int totalActiveWallets;

  @override
  List<Object?> get props => [
    totalProfits,
    totalCollectedProfit,
    totalUncollectedProfit,
    totalBalance,
    walletsWithCurrentProfit,
    totalActiveWallets,
  ];
}
