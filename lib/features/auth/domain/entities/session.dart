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
    this.subscriptionStatus,
    this.subscriptionExpireDate,
    this.planName,
    this.planId,
    this.renewalRequestStatus,
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
  final String? subscriptionStatus;
  final DateTime? subscriptionExpireDate;
  final String? planName;
  final String? planId;
  final String? renewalRequestStatus;

  bool get isOwner => role == UserRole.owner;

  bool get isUser => role == UserRole.user;

  bool get isSystemAdmin => backendRole.trim().toUpperCase() == 'SYSTEM_ADMIN';

  bool get hasSupportedRole => isOwner || isUser || isSystemAdmin;

  bool get hasSubscriptionData =>
      _normalizeString(subscriptionStatus) != null ||
      subscriptionExpireDate != null ||
      _normalizeString(planName) != null ||
      _normalizeString(planId) != null ||
      _normalizeString(renewalRequestStatus) != null;

  bool get isSubscriptionExpired {
    final normalizedStatus = _normalizeString(subscriptionStatus);
    if (normalizedStatus == null) {
      return false;
    }

    return normalizedStatus.contains('EXPIRED');
  }

  bool get isSubscriptionAllowed => !isSubscriptionExpired;

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
      'subscriptionStatus': subscriptionStatus,
      'subscriptionExpireDate': subscriptionExpireDate?.toIso8601String(),
      'planName': planName,
      'planId': planId,
      'renewalRequestStatus': renewalRequestStatus,
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
      subscriptionStatus: _readString(json, const ['subscriptionStatus']),
      subscriptionExpireDate: _parseDateTime(
        json['subscriptionExpireDate'] ?? json['expireDate'],
      ),
      planName: _readString(json, const ['planName']),
      planId: _readString(json, const ['planId']),
      renewalRequestStatus: _readString(json, const ['renewalRequestStatus']),
    );
  }

  factory Session.fromApiPayload(
    Map<String, dynamic> payload, {
    required String accessToken,
    required String refreshToken,
    Session? fallbackSession,
    DateTime? tokenExpiresAt,
  }) {
    final backendRole =
        _readString(payload, const [
          'backendRole',
          'role',
          'roles',
          'authorities',
        ]) ??
        fallbackSession?.backendRole ??
        '';
    final roleName = _readString(payload, const ['role']);

    return Session(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username:
          _readString(payload, const ['username', 'userName', 'email']) ??
          fallbackSession?.username ??
          '',
      role: _parseRole(roleName, backendRole),
      backendRole: backendRole,
      tenantId:
          _readString(payload, const ['tenantId', 'tenant_id', 'tenant']) ??
          fallbackSession?.tenantId ??
          '',
      tenantName:
          _readString(payload, const ['tenantName', 'workspaceName']) ??
          fallbackSession?.tenantName,
      userId:
          _readString(payload, const ['userId', 'user_id', 'id']) ??
          fallbackSession?.userId ??
          '',
      displayName:
          _readString(payload, const ['displayName', 'name', 'fullName']) ??
          fallbackSession?.displayName ??
          '',
      tokenExpiresAt: tokenExpiresAt ?? fallbackSession?.tokenExpiresAt,
      subscriptionStatus:
          _readString(payload, const ['subscriptionStatus']) ??
          fallbackSession?.subscriptionStatus,
      subscriptionExpireDate:
          _parseDateTime(
            payload['subscriptionExpireDate'] ?? payload['expireDate'],
          ) ??
          fallbackSession?.subscriptionExpireDate,
      planName:
          _readString(payload, const ['planName']) ?? fallbackSession?.planName,
      planId: _readString(payload, const ['planId']) ?? fallbackSession?.planId,
      renewalRequestStatus:
          _readString(payload, const ['renewalRequestStatus']) ??
          fallbackSession?.renewalRequestStatus,
    );
  }

  Session copyWith({
    String? accessToken,
    String? refreshToken,
    String? username,
    UserRole? role,
    String? backendRole,
    String? tenantId,
    String? userId,
    String? displayName,
    Object? tenantName = _sentinel,
    DateTime? tokenExpiresAt,
    Object? subscriptionStatus = _sentinel,
    Object? subscriptionExpireDate = _sentinel,
    Object? planName = _sentinel,
    Object? planId = _sentinel,
    Object? renewalRequestStatus = _sentinel,
  }) {
    return Session(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      username: username ?? this.username,
      role: role ?? this.role,
      backendRole: backendRole ?? this.backendRole,
      tenantId: tenantId ?? this.tenantId,
      tenantName: identical(tenantName, _sentinel)
          ? this.tenantName
          : tenantName as String?,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      tokenExpiresAt: tokenExpiresAt ?? this.tokenExpiresAt,
      subscriptionStatus: identical(subscriptionStatus, _sentinel)
          ? this.subscriptionStatus
          : subscriptionStatus as String?,
      subscriptionExpireDate: identical(subscriptionExpireDate, _sentinel)
          ? this.subscriptionExpireDate
          : subscriptionExpireDate as DateTime?,
      planName: identical(planName, _sentinel)
          ? this.planName
          : planName as String?,
      planId: identical(planId, _sentinel) ? this.planId : planId as String?,
      renewalRequestStatus: identical(renewalRequestStatus, _sentinel)
          ? this.renewalRequestStatus
          : renewalRequestStatus as String?,
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
    subscriptionStatus,
    subscriptionExpireDate,
    planName,
    planId,
    renewalRequestStatus,
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

  static String? _normalizeString(String? value) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return null;
    }

    return normalized.toUpperCase();
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

const _sentinel = Object();
