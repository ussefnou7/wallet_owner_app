import 'package:flutter/foundation.dart';

import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.username,
    required super.role,
    required super.tenantName,
    super.backendRole,
    super.tenantId,
    super.branchId,
    super.branchName,
    super.active,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    final active = _boolFromJson(json['active'] ?? json['isActive']) ?? true;
    return AppUserModel(
      id: (json['id'] as String?) ?? (json['userId'] as String?) ?? '',
      username: (json['username'] as String?) ?? '',
      role: Session.fromBackendRole(json['role'] as String?),
      backendRole: (json['role'] as String?) ?? '',
      tenantName: (json['tenantName'] as String?) ?? '',
      tenantId: json['tenantId'] as String?,
      branchId: json['branchId'] as String?,
      branchName: json['branchName'] as String?,
      active: active,
    );
  }
}

bool? _boolFromJson(Object? value) {
  if (value is bool) {
    return value;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true') {
      return true;
    }
    if (normalized == 'false') {
      return false;
    }
  }
  return null;
}

@immutable
class CreateUserRequestModel {
  const CreateUserRequestModel({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

@immutable
class UpdateUserRequestModel {
  const UpdateUserRequestModel({
    required this.username,
    this.password,
    required this.active,
  });

  final String username;
  final String? password;
  final bool active;

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{'username': username, 'active': active};

    if (password != null && password!.trim().isNotEmpty) {
      json['password'] = password;
    }

    return json;
  }
}

@immutable
class AssignUserBranchRequestModel {
  const AssignUserBranchRequestModel({required this.branchId});

  final String branchId;

  Map<String, dynamic> toJson() => {'branchId': branchId};
}
