import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.username,
    required super.role,
    required super.tenantName,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      username: (json['username'] as String?) ?? '',
      role: Session.fromBackendRole(json['role'] as String?),
      tenantName: (json['tenantName'] as String?) ?? '',
    );
  }
}
