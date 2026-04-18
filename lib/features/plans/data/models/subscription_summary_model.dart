import '../../domain/entities/subscription_summary.dart';

class SubscriptionSummaryModel extends SubscriptionSummary {
  const SubscriptionSummaryModel({
    required super.planId,
    required super.planName,
    required super.status,
    required super.renewalDate,
    required super.maxUsers,
    required super.maxWallets,
    required super.maxBranches,
    required super.activeUsers,
    required super.activeWallets,
    required super.activeBranches,
  });

  factory SubscriptionSummaryModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionSummaryModel(
      planId: json['planId'] as String,
      planName: json['planName'] as String,
      status: SubscriptionStatus.values.byName(json['status'] as String),
      renewalDate: DateTime.parse(json['renewalDate'] as String),
      maxUsers: json['maxUsers'] as int,
      maxWallets: json['maxWallets'] as int,
      maxBranches: json['maxBranches'] as int,
      activeUsers: json['activeUsers'] as int,
      activeWallets: json['activeWallets'] as int,
      activeBranches: json['activeBranches'] as int,
    );
  }
}
