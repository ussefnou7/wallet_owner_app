import '../../domain/entities/wallet.dart';

class WalletModel extends Wallet {
  const WalletModel({
    required super.id,
    super.tenantId,
    super.tenantName,
    super.branchId,
    required super.name,
    super.number,
    required super.code,
    required super.balance,
    super.walletProfit,
    super.cashProfit,
    super.dailyLimit,
    super.monthlyLimit,
    super.dailySpent,
    super.monthlySpent,
    super.dailyPercent,
    super.monthlyPercent,
    super.active,
    required super.status,
    super.type,
    super.rawType,
    super.createdAt,
    super.updatedAt,
    required super.transactionCount,
    super.branchName,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    final status = json['status'] as String?;
    final active = json['active'] as bool? ?? status?.toLowerCase() == 'active';
    final number = json['number'] as String?;
    final code = json['code'] as String? ?? number ?? json['id'] as String;
    final rawType = json['type'] as String?;
    final branch = json['branch'];

    return WalletModel(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String?,
      tenantName: json['tenantName'] as String?,
      branchId: json['branchId'] as String?,
      name: json['name'] as String,
      number: number,
      code: code,
      balance: _doubleFromJson(json['balance']),
      walletProfit: _doubleFromJson(json['walletProfit']),
      cashProfit: _doubleFromJson(json['cashProfit']),
      dailyLimit: _doubleFromJson(json['dailyLimit']),
      monthlyLimit: _doubleFromJson(json['monthlyLimit']),
      dailySpent: _doubleFromJson(json['dailySpent']),
      monthlySpent: _doubleFromJson(json['monthlySpent']),
      dailyPercent: _doubleFromJson(json['dailyPercent']),
      monthlyPercent: _doubleFromJson(json['monthlyPercent']),
      active: active,
      status: active ? WalletStatus.active : WalletStatus.inactive,
      type: _walletTypeFromJson(rawType),
      rawType: rawType,
      createdAt: _dateTimeFromJson(json['createdAt']),
      updatedAt: _dateTimeFromJson(json['updatedAt']),
      transactionCount: json['transactionCount'] as int? ?? 0,
      branchName:
          json['branchName'] as String? ??
          (branch is Map<String, dynamic> ? branch['name'] as String? : null),
    );
  }
}

class CreateWalletRequestModel {
  const CreateWalletRequestModel({
    required this.name,
    required this.number,
    required this.branchId,
    required this.balance,
    required this.dailyLimit,
    required this.monthlyLimit,
    required this.type,
    required this.tenantId,
  });

  final String name;
  final String number;
  final String branchId;
  final double balance;
  final double dailyLimit;
  final double monthlyLimit;
  final String type;
  final String tenantId;

  Map<String, dynamic> toJson() => {
        'name': name,
        'number': number,
        'branchId': branchId,
        'balance': balance,
        'dailyLimit': dailyLimit,
        'monthlyLimit': monthlyLimit,
        'type': type,
        'tenantId': tenantId,
      };
}

class UpdateWalletRequestModel {
  const UpdateWalletRequestModel({
    required this.name,
    required this.active,
    required this.dailyLimit,
    required this.monthlyLimit,
  });

  final String name;
  final bool active;
  final double dailyLimit;
  final double monthlyLimit;

  Map<String, dynamic> toJson() => {
        'name': name,
        'active': active,
        'dailyLimit': dailyLimit,
        'monthlyLimit': monthlyLimit,
      };
}

double _doubleFromJson(Object? value) {
  if (value is num) {
    return value.toDouble();
  }

  return 0;
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }

  return null;
}

WalletType _walletTypeFromJson(String? value) {
  return switch (value) {
    'WALLET_TYPE' => WalletType.walletType,
    _ => WalletType.unknown,
  };
}
