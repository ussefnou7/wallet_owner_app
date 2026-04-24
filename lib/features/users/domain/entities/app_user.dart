import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/session.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.username,
    required this.role,
    required this.tenantName,
  });

  final String id;
  final String username;
  final UserRole role;
  final String tenantName;

  @override
  List<Object?> get props => [id, username, role, tenantName];
}
