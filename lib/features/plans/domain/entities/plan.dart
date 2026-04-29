import 'package:equatable/equatable.dart';

class Plan extends Equatable {
  const Plan({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.maxUsers,
    required this.maxWallets,
    required this.maxBranches,
    required this.active,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final num price;
  final int maxUsers;
  final int maxWallets;
  final int maxBranches;
  final bool active;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    maxUsers,
    maxWallets,
    maxBranches,
    active,
    createdAt,
    updatedAt,
  ];
}
