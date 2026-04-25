import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/session.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.username,
    required this.role,
    required this.tenantName,
    this.tenantId,
    this.branchId,
    this.branchName,
    this.active = true,
  });

  final String id;
  final String username;
  final UserRole role;
  final String tenantName;
  final String? tenantId;
  final String? branchId;
  final String? branchName;
  final bool active;

  @override
  List<Object?> get props => [
    id,
    username,
    role,
    tenantName,
    tenantId,
    branchId,
    branchName,
    active,
  ];
}
