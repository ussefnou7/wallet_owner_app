import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/session.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.username,
    required this.role,
    required this.tenantName,
    this.backendRole = '',
    this.tenantId,
    this.branchId,
    this.branchName,
    this.active = true,
  });

  final String id;
  final String username;
  final UserRole role;
  final String tenantName;
  final String backendRole;
  final String? tenantId;
  final String? branchId;
  final String? branchName;
  final bool active;

  bool get isOwner => role == UserRole.owner;

  bool get isUser => role == UserRole.user;

  bool get isSystemAdmin => backendRole.trim().toUpperCase() == 'SYSTEM_ADMIN';

  String get roleLabel =>
      backendRole.trim().isEmpty ? role.name.toUpperCase() : backendRole;

  @override
  List<Object?> get props => [
    id,
    username,
    role,
    tenantName,
    backendRole,
    tenantId,
    branchId,
    branchName,
    active,
  ];
}
