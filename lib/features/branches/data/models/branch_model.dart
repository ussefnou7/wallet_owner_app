import '../../domain/entities/branch.dart';

class BranchModel extends Branch {
  const BranchModel({
    required super.id,
    required super.name,
    required super.code,
    required super.usersCount,
    required super.walletsCount,
    required super.status,
    super.location,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    final statusValue = json['status'] as String?;
    final activeValue = json['active'] as bool?;

    return BranchModel(
      id: json['branchId'] as String? ?? json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      code:
          json['code'] as String? ??
          json['tenantName'] as String? ??
          json['name'] as String? ??
          '',
      usersCount:
          (json['usersCount'] as num?)?.toInt() ??
          (json['userCount'] as num?)?.toInt() ??
          0,
      walletsCount:
          (json['walletsCount'] as num?)?.toInt() ??
          (json['walletCount'] as num?)?.toInt() ??
          0,
      status: _statusFromJson(statusValue, activeValue),
      location: json['location'] as String?,
    );
  }
}

BranchStatus _statusFromJson(String? statusValue, bool? activeValue) {
  if (statusValue != null && statusValue.isNotEmpty) {
    return BranchStatus.values.byName(statusValue);
  }

  if (activeValue == true) {
    return BranchStatus.active;
  }

  return BranchStatus.inactive;
}
