import 'package:equatable/equatable.dart';

import 'app_notification.dart';

class NotificationUnreadGrouped extends Equatable {
  const NotificationUnreadGrouped({
    required this.unreadCount,
    required this.important,
    required this.low,
  });

  final int unreadCount;
  final List<AppNotification> important;
  final List<AppNotification> low;

  @override
  List<Object?> get props => [unreadCount, important, low];
}
