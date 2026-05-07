import 'package:equatable/equatable.dart';

class UserPerformanceResponse extends Equatable {
  const UserPerformanceResponse({required this.summary, required this.users});

  final UserPerformanceSummary summary;
  final List<UserPerformanceUser> users;

  @override
  List<Object?> get props => [summary, users];
}

class UserPerformanceSummary extends Equatable {
  const UserPerformanceSummary({
    required this.activeUsers,
    required this.totalTransactions,
    required this.totalCredits,
    required this.totalDebits,
    required this.totalAmount,
    required this.totalUserProfit,
  });

  final int activeUsers;
  final int totalTransactions;
  final double totalCredits;
  final double totalDebits;
  final double totalAmount;
  final double totalUserProfit;

  @override
  List<Object?> get props => [
    activeUsers,
    totalTransactions,
    totalCredits,
    totalDebits,
    totalAmount,
    totalUserProfit,
  ];
}

class UserPerformanceUser extends Equatable {
  const UserPerformanceUser({
    required this.userId,
    required this.username,
    required this.transactionCount,
    required this.creditCount,
    required this.debitCount,
    required this.totalCredits,
    required this.totalDebits,
    required this.totalAmount,
    required this.userProfit,
  });

  final String userId;
  final String username;
  final int transactionCount;
  final int creditCount;
  final int debitCount;
  final double totalCredits;
  final double totalDebits;
  final double totalAmount;
  final double userProfit;

  @override
  List<Object?> get props => [
    userId,
    username,
    transactionCount,
    creditCount,
    debitCount,
    totalCredits,
    totalDebits,
    totalAmount,
    userProfit,
  ];
}
