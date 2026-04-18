import '../../../auth/domain/entities/session.dart';
import '../../domain/entities/app_user.dart';

class AppUserModel extends AppUser {
  const AppUserModel({
    required super.id,
    required super.fullName,
    required super.role,
    required super.email,
    required super.status,
    required super.walletCount,
    super.branchName,
    super.phone,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      role: UserRole.values.byName(json['role'] as String),
      email: json['email'] as String,
      status: AppUserStatus.values.byName(json['status'] as String),
      walletCount: json['walletCount'] as int,
      branchName: json['branchName'] as String?,
      phone: json['phone'] as String?,
    );
  }
}
