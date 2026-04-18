import '../../domain/entities/plan.dart';

class PlanModel extends Plan {
  const PlanModel({
    required super.id,
    required super.name,
    required super.description,
    required super.maxUsers,
    required super.maxWallets,
    required super.maxBranches,
    super.badge,
  });

  factory PlanModel.fromJson(Map<String, dynamic> json) {
    return PlanModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      maxUsers: json['maxUsers'] as int,
      maxWallets: json['maxWallets'] as int,
      maxBranches: json['maxBranches'] as int,
      badge: PlanBadge.values.byName(json['badge'] as String),
    );
  }
}
