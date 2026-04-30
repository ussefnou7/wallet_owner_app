import 'package:equatable/equatable.dart';

enum UserRole { owner, user, unknown }

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

  bool get isOwner => role == UserRole.owner;

  bool get isUser => role == UserRole.user;

  bool get hasSupportedRole => isOwner || isUser;

  String get roleLabel =>
      backendRole.isEmpty ? role.name.toUpperCase() : backendRole;

  String? get email => username.contains('@') ? username : null;

  String get tenantDisplayName {
    final explicitName = tenantName?.trim() ?? '';
    if (explicitName.isNotEmpty) {
      return explicitName;
    }

    final normalizedTenantId = tenantId.trim();
    if (normalizedTenantId.isEmpty || _looksLikeUuid(normalizedTenantId)) {
      return '';
    }

    return _toDisplayLabel(normalizedTenantId);
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'role': role.name,
      'backendRole': backendRole,
      'tenantId': tenantId,
      'tenantName': tenantName,
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
        (json['backendRole'] as String?) ?? (json['role'] as String?) ?? '';
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
      tenantName: json['tenantName'] as String?,
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
    tenantName,
    userId,
    displayName,
    tokenExpiresAt,
  ];

  static UserRole fromBackendRole(String? value) {
    final normalized = value?.trim().toUpperCase() ?? '';
    if (normalized == 'OWNER') {
      return UserRole.owner;
    }

    if (normalized == 'USER') {
      return UserRole.user;
    }

    return UserRole.unknown;
  }

  static UserRole _parseRole(String? roleName, String backendRole) {
    final parsedStoredRole = fromBackendRole(roleName);
    if (parsedStoredRole != UserRole.unknown) {
      return parsedStoredRole;
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

  static bool _looksLikeUuid(String value) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
    ).hasMatch(value);
  }
}
