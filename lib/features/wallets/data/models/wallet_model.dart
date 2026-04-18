import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    required super.name,
    required super.code,
    required super.balance,
    required super.status,
    required super.transactionCount,
    super.branchName,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      balance: (json['balance'] as num).toDouble(),
      status: WalletStatus.values.byName(json['status'] as String),
      transactionCount: json['transactionCount'] as int,
      branchName: json['branchName'] as String?,
    );
  }
}
