import 'package:equatable/equatable.dart';

enum SubscriptionStatus { active, expiringSoon, expired }

class SubscriptionSummary extends Equatable {
  const SubscriptionSummary({
    required this.planId,
    required this.planName,
    required this.status,
    required this.renewalDate,
    required this.maxUsers,
    required this.maxWallets,
    required this.maxBranches,
    required this.activeUsers,
    required this.activeWallets,
    required this.activeBranches,
  });

  final String planId;
  final String planName;
  final SubscriptionStatus status;
  final DateTime renewalDate;
  final int maxUsers;
  final int maxWallets;
  final int maxBranches;
  final int activeUsers;
  final int activeWallets;
  final int activeBranches;

  String get statusLabel => switch (status) {
    SubscriptionStatus.active => 'Active',
    SubscriptionStatus.expiringSoon => 'Expiring Soon',
    SubscriptionStatus.expired => 'Expired',
  };

  @override
  List<Object?> get props => [
    planId,
    planName,
    status,
    renewalDate,
    maxUsers,
    maxWallets,
    maxBranches,
    activeUsers,
    activeWallets,
    activeBranches,
  ];
}
