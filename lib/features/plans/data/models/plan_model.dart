import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.maxUsers,
    required super.maxWallets,
    required super.maxBranches,
    required super.active,
    super.createdAt,
    super.updatedAt,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: json['price'] as num,
      maxUsers: json['maxUsers'] as int,
      maxWallets: json['maxWallets'] as int,
      maxBranches: json['maxBranches'] as int,
      active: json['active'] as bool? ?? true,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }
}
