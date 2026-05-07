import 'package:equatable/equatable.dart';

class AppException extends Equatable implements Exception {
  static const Set<String> _sessionInvalidationCodes = {
    'TOKEN_EXPIRED',
    'INVALID_TOKEN',
    'ACCOUNT_INACTIVE',
  };

  const AppException({
    required this.code,
    required this.message,
    this.status,
    this.details,
    this.traceId,
  });

  final String code;
  final String message;
  final int? status;
  final Object? details;
  final String? traceId;

  bool get isUnauthorized => status == 401 || code == 'UNAUTHORIZED';

  bool get isForbidden => status == 403 || code == 'FORBIDDEN';

  bool get isSubscriptionExpired =>
      code.trim().toUpperCase() == 'SUBSCRIPTION_EXPIRED';

  bool get requiresSessionInvalidation =>
      _sessionInvalidationCodes.contains(code.toUpperCase());

  @override
  List<Object?> get props => [code, message, status, details, traceId];

  @override
  String toString() => message;
}
