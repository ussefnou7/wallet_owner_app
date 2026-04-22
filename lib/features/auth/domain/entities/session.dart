import 'package:equatable/equatable.dart';

enum UserRole { owner, user }

class Session extends Equatable {
  const Session({
    required this.accessToken,
    required this.refreshToken,
    required this.username,
    required this.role,
    required this.backendRole,
    required this.tenantId,
    required this.userId,
    required this.displayName,
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
  final DateTime? tokenExpiresAt;

  String get roleLabel => backendRole.isEmpty ? role.name.toUpperCase() : backendRole;

  String? get email => username.contains('@') ? username : null;

  String get tenantName => _toDisplayLabel(tenantId);

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role.name,
      'backendRole': backendRole,
      'tenantId': tenantId,
      'userId': userId,
      'displayName': displayName,
      'tokenExpiresAt': tokenExpiresAt?.toIso8601String(),
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    final accessToken =
        (json['accessToken'] as String?) ?? (json['token'] as String?);
    if (accessToken == null || accessToken.trim().isEmpty) {
      throw const FormatException('Session token is missing');
    }

    final backendRole =
        (json['backendRole'] as String?) ?? (json['role'] as String?) ?? 'OWNER';
    final roleName = json['role'] as String?;

    return Session(
      accessToken: accessToken.trim(),
      refreshToken: (json['refreshToken'] as String?) ?? '',
      username:
          (json['username'] as String?) ??
          (json['displayName'] as String?) ??
          '',
      role: _parseRole(roleName, backendRole),
      backendRole: backendRole,
      tenantId: (json['tenantId'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? '',
      displayName:
          (json['displayName'] as String?) ??
          (json['username'] as String?) ??
          '',
      tokenExpiresAt: _parseDateTime(json['tokenExpiresAt']),
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    username,
    role,
    backendRole,
    tenantId,
    userId,
    displayName,
    tokenExpiresAt,
  ];

  static UserRole fromBackendRole(String? value) {
    final normalized = value?.trim().toLowerCase() ?? '';
    if (normalized == 'user') {
      return UserRole.user;
    }

    return UserRole.owner;
  }

  static UserRole _parseRole(String? roleName, String backendRole) {
    final normalized = roleName?.trim().toLowerCase();
    if (normalized != null && normalized.isNotEmpty) {
      for (final role in UserRole.values) {
        if (role.name == normalized) {
          return role;
        }
      }
    }

    return fromBackendRole(backendRole);
  }

  static DateTime? _parseDateTime(Object? value) {
    if (value is String && value.trim().isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static String _toDisplayLabel(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      return '';
    }

    return normalized
        .split(RegExp(r'[-_\s]+'))
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) =>
              '${segment[0].toUpperCase()}${segment.substring(1).toLowerCase()}',
        )
        .join(' ');
  }
}
