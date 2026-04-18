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
    return BranchModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      usersCount: json['usersCount'] as int,
      walletsCount: json['walletsCount'] as int,
      status: BranchStatus.values.byName(json['status'] as String),
      location: json['location'] as String?,
    );
  }
}
