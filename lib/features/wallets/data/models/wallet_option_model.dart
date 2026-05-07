import '../../domain/entities/wallet_option.dart';

class WalletOptionModel extends WalletOption {
  const WalletOptionModel({
    required super.id,
    required super.name,
    required super.number,
    required super.branchId,
  });

  factory WalletOptionModel.fromJson(Map<String, dynamic> json) {
    final branch = json['branch'];

    return WalletOptionModel(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      number:
          _stringFromJson(json['number']) ??
          _stringFromJson(json['code']) ??
          _stringFromJson(json['walletNumber']) ??
          '',
      branchId:
          _stringFromJson(json['branchId']) ??
          (branch is Map<String, dynamic> ? _stringFromJson(branch['id']) : null) ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'number': number,
    'branchId': branchId,
  };
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = _stringFromJson(json[key]);
  if (value != null) {
    return value;
  }

  throw FormatException('Wallet option is missing required "$key" field.');
}

String? _stringFromJson(Object? value) {
  if (value == null) {
    return null;
  }

  final stringValue = switch (value) {
    final String string => string,
    _ => '$value',
  };

  final trimmed = stringValue.trim();
  if (trimmed.isEmpty) {
    return null;
  }

  return trimmed;
}
