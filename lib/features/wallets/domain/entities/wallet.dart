import 'package:equatable/equatable.dart';

enum WalletStatus { active, inactive }

class Wallet extends Equatable {
  const Wallet({
    required this.id,
    required this.name,
    required this.code,
    required this.balance,
    required this.status,
    required this.transactionCount,
    this.branchName,
  });

  final String id;
  final String name;
  final String code;
  final double balance;
  final WalletStatus status;
  final int transactionCount;
  final String? branchName;

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    balance,
    status,
    transactionCount,
    branchName,
  ];
}
