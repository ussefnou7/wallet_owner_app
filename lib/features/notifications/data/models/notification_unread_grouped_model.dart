import '../../domain/entities/notification_unread_grouped.dart';
import 'notification_model.dart';

class NotificationUnreadGroupedModel extends NotificationUnreadGrouped {
  const NotificationUnreadGroupedModel({
    required super.unreadCount,
    required super.important,
    required super.low,
  });

  factory NotificationUnreadGroupedModel.fromJson(Map<String, dynamic> json) {
    return NotificationUnreadGroupedModel(
      unreadCount: _countFromJson(json['unreadCount']),
      important: _notificationsFromJson(json['important']),
      low: _notificationsFromJson(json['low']),
    );
  }
}

int _countFromJson(Object? value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? 0;
  }
  return 0;
}

List<NotificationModel> _notificationsFromJson(Object? value) {
  if (value is! List) {
    return const [];
  }

  return value
      .whereType<Map>()
      .map(
        (item) => NotificationModel.fromJson(
          item.map((key, value) => MapEntry(key.toString(), value)),
        ),
      )
      .toList();
}
