import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/session.dart';
import '../services/jwt_decoder.dart';

class LoginResponseModel {
  const LoginResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.role,
    required this.backendRole,
    required this.tenantId,
    required this.userId,
    required this.displayName,
    this.tenantName,
    this.tokenExpiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final String username;
  final UserRole role;
  final String backendRole;
  final String tenantId;
  final String userId;
  final String displayName;
  final String? tenantName;
  final DateTime? tokenExpiresAt;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final payload = _unwrapPayload(json);
    final accessToken = _readString(payload, const [
      'token',
      'accessToken',
      'access_token',
      'jwt',
    ]);
    if (accessToken == null || accessToken.isEmpty) {
      throw const AppException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected login response. Access token is missing.',
      );
    }

    final claims = JwtDecoder.tryDecodePayload(accessToken) ?? const {};
    final resolvedUsername =
        _readString(payload, const ['username', 'userName']) ??
        _readString(claims, const ['username', 'preferred_username', 'sub']) ??
        '';
    final resolvedBackendRole =
        _readString(payload, const ['role', 'roles', 'authorities']) ??
        _readString(claims, const [
          'role',
          'user_role',
          'roles',
          'authorities',
          'scope',
        ]) ??
        '';
    final resolvedRole = Session.fromBackendRole(resolvedBackendRole);
    final resolvedTenantId =
        _readString(claims, const ['tenantId', 'tenant_id', 'tenant']) ?? '';
    final resolvedUserId =
        _readString(claims, const ['userId', 'user_id']) ?? '';
    final resolvedTenantName =
        _readString(payload, const ['tenantName', 'workspaceName']) ??
        _readString(claims, const ['tenantName', 'workspaceName']);
    final resolvedDisplayName =
        _readString(payload, const ['displayName', 'name', 'fullName']) ??
        _readString(claims, const ['name']) ??
        resolvedUsername;
    final resolvedExpiry = JwtDecoder.readExpirationFromClaims(claims);

    return LoginResponseModel(
      accessToken: accessToken,
      refreshToken:
          _readString(payload, const ['refreshToken', 'refresh_token']) ?? '',
      username: resolvedUsername,
      role: resolvedRole,
      backendRole: resolvedBackendRole,
      tenantId: resolvedTenantId,
      tenantName: resolvedTenantName,
      userId: resolvedUserId,
      displayName: resolvedDisplayName,
      tokenExpiresAt: resolvedExpiry,
    );
  }

  Session toSession() {
    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      role: role,
      backendRole: backendRole,
      tenantId: tenantId,
      tenantName: tenantName,
      userId: userId,
      displayName: displayName,
      tokenExpiresAt: tokenExpiresAt,
    );
  }

  static Map<String, dynamic> _unwrapPayload(Map<String, dynamic> json) {
    final nested = json['data'];
    if (nested is Map<String, dynamic>) {
      return nested;
    }

    return json;
  }

  static String? _readString(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key];
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
      if (value is List<Object?>) {
        for (final item in value) {
          if (item is String && item.trim().isNotEmpty) {
            return item.trim();
          }
        }
      }
    }
    return null;
  }
}
