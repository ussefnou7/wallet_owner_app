import 'package:equatable/equatable.dart';

enum NotificationType {
  transactionCreated,
  walletDailyLimitNear,
  walletDailyLimitExceeded,
  walletMonthlyLimitNear,
  walletMonthlyLimitExceeded,
  unknown,
}

enum NotificationPriority { low, medium, high }

enum NotificationSeverity { info, warning, danger }

class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.type,
    required this.priority,
    required this.severity,
    required this.titleKey,
    required this.messageKey,
    required this.payload,
    required this.createdAt,
    this.targetType,
    this.targetId,
  });

  final String id;
  final NotificationType type;
  final NotificationPriority priority;
  final NotificationSeverity severity;
  final String titleKey;
  final String messageKey;
  final Map<String, dynamic> payload;
  final String? targetType;
  final String? targetId;
  final DateTime createdAt;

  @override
  List<Object?> get props => [
    id,
    type,
    priority,
    severity,
    titleKey,
    messageKey,
    payload,
    targetType,
    targetId,
    createdAt,
  ];
}
