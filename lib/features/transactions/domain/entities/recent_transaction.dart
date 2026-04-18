import 'package:equatable/equatable.dart';

enum TransactionType { credit, debit }

class RecentTransaction extends Equatable {
  const RecentTransaction({
    required this.id,
    required this.walletName,
    required this.amount,
    required this.type,
  });

  final String id;
  final String walletName;
  final double amount;
  final TransactionType type;

  @override
  List<Object?> get props => [id, walletName, amount, type];
}
