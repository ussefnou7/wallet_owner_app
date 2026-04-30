import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/notification_count.dart';
import '../entities/notification_unread_grouped.dart';

final notificationsRepositoryProvider = Provider<NotificationsRepository>((
  ref,
) {
  throw UnimplementedError(
    'notificationsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class NotificationsRepository {
  Future<NotificationUnreadGrouped> getUnreadNotifications({int limit = 20});

  Future<NotificationCount> getUnreadCount();

  Future<void> markOneAsRead(String notificationId);

  Future<void> markLowAsRead();

  Future<void> markAllAsRead();
}
