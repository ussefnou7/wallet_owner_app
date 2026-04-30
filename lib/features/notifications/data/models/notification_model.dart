import '../../domain/entities/app_notification.dart';

class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.type,
    required super.priority,
    required super.severity,
    required super.titleKey,
    required super.messageKey,
    required super.payload,
    required super.createdAt,
    super.targetType,
    super.targetId,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      type: _notificationTypeFromJson(json['type'] as String?),
      priority: _notificationPriorityFromJson(json['priority'] as String?),
      severity: _notificationSeverityFromJson(json['severity'] as String?),
      titleKey: json['titleKey'] as String? ?? '',
      messageKey: json['messageKey'] as String? ?? '',
      payload: _payloadFromJson(json['payload']),
      targetType: json['targetType'] as String?,
      targetId: json['targetId'] as String?,
      createdAt: _dateTimeFromJson(json['createdAt']),
    );
  }
}

NotificationType _notificationTypeFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'TRANSACTION_CREATED':
      return NotificationType.transactionCreated;
    case 'WALLET_DAILY_LIMIT_NEAR':
      return NotificationType.walletDailyLimitNear;
    case 'WALLET_DAILY_LIMIT_EXCEEDED':
      return NotificationType.walletDailyLimitExceeded;
    case 'WALLET_MONTHLY_LIMIT_NEAR':
      return NotificationType.walletMonthlyLimitNear;
    case 'WALLET_MONTHLY_LIMIT_EXCEEDED':
      return NotificationType.walletMonthlyLimitExceeded;
    default:
      return NotificationType.unknown;
  }
}

NotificationPriority _notificationPriorityFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'HIGH':
      return NotificationPriority.high;
    case 'MEDIUM':
      return NotificationPriority.medium;
    case 'LOW':
    default:
      return NotificationPriority.low;
  }
}

NotificationSeverity _notificationSeverityFromJson(String? value) {
  switch (value?.toUpperCase()) {
    case 'DANGER':
      return NotificationSeverity.danger;
    case 'WARNING':
      return NotificationSeverity.warning;
    case 'INFO':
    default:
      return NotificationSeverity.info;
  }
}

Map<String, dynamic> _payloadFromJson(Object? value) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  if (value is Map) {
    return value.map((key, item) => MapEntry(key.toString(), item));
  }
  return const <String, dynamic>{};
}

DateTime _dateTimeFromJson(Object? value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value) ?? DateTime.now();
  }
  return DateTime.now();
}
