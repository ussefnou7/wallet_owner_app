import '../../../../core/network/api_result.dart';
import '../../domain/entities/notification_count.dart';
import '../../domain/entities/notification_unread_grouped.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_data_source.dart';

class AppNotificationsRepository implements NotificationsRepository {
  const AppNotificationsRepository({
    required NotificationsRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final NotificationsRemoteDataSource _remoteDataSource;

  @override
  Future<NotificationUnreadGrouped> getUnreadNotifications({int limit = 20}) {
    return _remoteDataSource.getUnreadNotifications(limit: limit).then(_unwrap);
  }

  @override
  Future<NotificationCount> getUnreadCount() {
    return _remoteDataSource.getUnreadCount().then(_unwrap);
  }

  @override
  Future<void> markOneAsRead(String notificationId) {
    return _remoteDataSource.markOneAsRead(notificationId).then(_unwrap);
  }

  @override
  Future<void> markLowAsRead() {
    return _remoteDataSource.markLowAsRead().then(_unwrap);
  }

  @override
  Future<void> markAllAsRead() {
    return _remoteDataSource.markAllAsRead().then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
