import 'package:equatable/equatable.dart';

enum PlanBadge { current, recommended, available }

class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.maxUsers,
    required this.maxWallets,
    required this.maxBranches,
    this.badge = PlanBadge.available,
  });

  final String id;
  final String name;
  final String description;
  final int maxUsers;
  final int maxWallets;
  final int maxBranches;
  final PlanBadge badge;

  bool get isCurrent => badge == PlanBadge.current;

  bool get isRecommended => badge == PlanBadge.recommended;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    maxUsers,
    maxWallets,
    maxBranches,
    badge,
  ];
}
