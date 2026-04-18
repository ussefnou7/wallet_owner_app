import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/session.dart';

enum AppUserStatus { active, inactive }

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.fullName,
    required this.role,
    required this.email,
    required this.status,
    required this.walletCount,
    this.branchName,
    this.phone,
  });

  final String id;
  final String fullName;
  final UserRole role;
  final String email;
  final AppUserStatus status;
  final int walletCount;
  final String? branchName;
  final String? phone;

  @override
  List<Object?> get props => [
    id,
    fullName,
    role,
    email,
    status,
    walletCount,
    branchName,
    phone,
  ];
}
