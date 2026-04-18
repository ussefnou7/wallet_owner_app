import '../../domain/entities/session.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.role,
    required this.tenantId,
    required this.userId,
    required this.displayName,
  });

  final String accessToken;
  final String refreshToken;
  final UserRole role;
  final String tenantId;
  final String userId;
  final String displayName;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      role: UserRole.values.byName(json['role'] as String),
      tenantId: json['tenantId'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
    );
  }

  Session toSession() {
    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      role: role,
      tenantId: tenantId,
      userId: userId,
      displayName: displayName,
    );
  }
}
