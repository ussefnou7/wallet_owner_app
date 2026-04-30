import '../../domain/entities/notification_count.dart';

class NotificationCountModel extends NotificationCount {
  const NotificationCountModel({required super.count});

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) {
    final raw = json['count'];
    if (raw is num) {
      return NotificationCountModel(count: raw.toInt());
    }
    if (raw is String) {
      return NotificationCountModel(count: int.tryParse(raw) ?? 0);
    }
    return const NotificationCountModel(count: 0);
  }
}
