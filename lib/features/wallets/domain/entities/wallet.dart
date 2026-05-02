import 'package:equatable/equatable.dart';

enum WalletStatus { active, inactive }

enum WalletType { walletType, unknown }

class Wallet extends Equatable {
  const Wallet({
    required this.id,
    required this.name,
    required this.code,
    required this.balance,
    required this.status,
    required this.transactionCount,
    this.tenantId,
    this.tenantName,
    this.branchId,
    this.number,
    this.walletProfit = 0,
    this.cashProfit = 0,
    this.dailyLimit = 0,
    this.monthlyLimit = 0,
    this.dailySpent = 0,
    this.monthlySpent = 0,
    this.dailyPercent = 0,
    this.monthlyPercent = 0,
    this.active = true,
    this.type = WalletType.unknown,
    this.rawType,
    this.createdAt,
    this.updatedAt,
    this.branchName,
    this.collectedAt,
    this.collectedByName,
    this.lastProfitCollectionAt,
  });

  final String id;
  final String? tenantId;
  final String? tenantName;
  final String? branchId;
  final String name;
  final String? number;
  final String code;
  final double balance;
  final double walletProfit;
  final double cashProfit;
  final double dailyLimit;
  final double monthlyLimit;
  final double dailySpent;
  final double monthlySpent;
  final double dailyPercent;
  final double monthlyPercent;
  final bool active;
  final WalletStatus status;
  final WalletType type;
  final String? rawType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int transactionCount;
  final String? branchName;
  final DateTime? collectedAt;
  final String? collectedByName;
  final DateTime? lastProfitCollectionAt;

  @override
  List<Object?> get props => [
    id,
    tenantId,
    tenantName,
    branchId,
    name,
    number,
    code,
    balance,
    walletProfit,
    cashProfit,
    dailyLimit,
    monthlyLimit,
    dailySpent,
    monthlySpent,
    dailyPercent,
    monthlyPercent,
    active,
    status,
    type,
    rawType,
    createdAt,
    updatedAt,
    transactionCount,
    branchName,
    collectedAt,
    collectedByName,
    lastProfitCollectionAt,
  ];
}
