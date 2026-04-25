import 'package:equatable/equatable.dart';

enum BranchStatus { active, inactive }

class Branch extends Equatable {
  const Branch({
    required this.id,
    required this.name,
    required this.code,
    required this.usersCount,
    required this.walletsCount,
    required this.status,
    this.tenantId,
    this.tenantName,
    this.location,
  });

  final String id;
  final String name;
  final String code;
  final int usersCount;
  final int walletsCount;
  final BranchStatus status;
  final String? tenantId;
  final String? tenantName;
  final String? location;

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    usersCount,
    walletsCount,
    status,
    tenantId,
    tenantName,
    location,
  ];
}
