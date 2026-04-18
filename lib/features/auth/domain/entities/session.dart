import 'package:equatable/equatable.dart';

enum UserRole { owner, user }

class Session extends Equatable {
  const Session({
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

  String get roleLabel => role.name.toUpperCase();

  String get tenantName => _toDisplayLabel(tenantId);

  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'tenantId': tenantId,
      'userId': userId,
      'displayName': displayName,
    };
  }

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      role: UserRole.values.byName(json['role'] as String),
      tenantId: json['tenantId'] as String,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
    );
  }

  @override
  List<Object?> get props => [
    accessToken,
    refreshToken,
    role,
    tenantId,
    userId,
    displayName,
  ];

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
