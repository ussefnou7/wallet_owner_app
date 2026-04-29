import 'package:flutter/foundation.dart';

import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.username,
    required super.role,
    required super.tenantName,
    super.tenantId,
    super.branchId,
    super.branchName,
    super.active,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    // If 'active' is not provided by the backend, default to true
    // as per AppUser entity's default value.
    final active = json['active'] as bool? ?? true;
    return AppUserModel(
      id: (json['id'] as String?) ?? (json['userId'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      role: Session.fromBackendRole(json['role'] as String?),
      tenantName: (json['tenantName'] as String?) ?? '',
      tenantId: json['tenantId'] as String?,
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String?,
      active: active,
    );
  }
}

@immutable
class CreateUserRequestModel {
  const CreateUserRequestModel({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
  };
}

@immutable
class UpdateUserRequestModel {
  const UpdateUserRequestModel({
    required this.username,
    required this.password,
    required this.active,
  });

  final String username;
  final String password;
  final bool active;

  Map<String, dynamic> toJson() => {
    'username': username,
    'password': password,
    'active': active,
  };
}

@immutable
class AssignUserBranchRequestModel {
  const AssignUserBranchRequestModel({required this.branchId});

  final String branchId;

  Map<String, dynamic> toJson() => {'branchId': branchId};
}
