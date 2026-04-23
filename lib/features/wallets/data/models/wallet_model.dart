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
      branchName: json['branchName'] as String?,
    );
  }
}

class CreateWalletRequestModel {
  const CreateWalletRequestModel({required this.name});

  final String name;

  Map<String, dynamic> toJson() => {'name': name};
}

class UpdateWalletRequestModel {
  const UpdateWalletRequestModel({required this.name, required this.active});

  final String name;
  final bool active;

  Map<String, dynamic> toJson() => {'name': name, 'active': active};
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
