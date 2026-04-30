import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_message_mapper.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsProvider, NotificationsState>((ref) {
      final repository = ref.watch(notificationsRepositoryProvider);
      return NotificationsProvider(repository);
    });

class NotificationsState {
  const NotificationsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.isActionLoading = false,
    this.errorMessage,
    this.unreadCount = 0,
    this.important = const [],
    this.low = const [],
  });

  final bool isLoading;
  final bool isRefreshing;
  final bool isActionLoading;
  final String? errorMessage;
  final int unreadCount;
  final List<AppNotification> important;
  final List<AppNotification> low;

  bool get hasNotifications => important.isNotEmpty || low.isNotEmpty;

  NotificationsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    bool? isActionLoading,
    String? errorMessage,
    int? unreadCount,
    List<AppNotification>? important,
    List<AppNotification>? low,
    bool clearError = false,
  }) {
    return NotificationsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isActionLoading: isActionLoading ?? this.isActionLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      unreadCount: unreadCount ?? this.unreadCount,
      important: important ?? this.important,
      low: low ?? this.low,
    );
  }
}

class NotificationsProvider extends StateNotifier<NotificationsState> {
  NotificationsProvider(this._repository) : super(const NotificationsState()) {
    loadUnreadCount();
  }

  final NotificationsRepository _repository;

  Future<void> loadUnreadCount() async {
    try {
      final count = await _repository.getUnreadCount();
      state = state.copyWith(unreadCount: count.count);
    } on AppException catch (_) {
      // Keep the existing badge count when count refresh fails.
    }
  }

  Future<void> loadUnreadNotifications({int limit = 20}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final grouped = await _repository.getUnreadNotifications(limit: limit);
      state = state.copyWith(
        isLoading: false,
        unreadCount: grouped.unreadCount,
        important: grouped.important,
        low: grouped.low,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: ErrorMessageMapper.getMessage(error),
      );
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);
    try {
      final grouped = await _repository.getUnreadNotifications();
      state = state.copyWith(
        isRefreshing: false,
        unreadCount: grouped.unreadCount,
        important: grouped.important,
        low: grouped.low,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isRefreshing: false,
        errorMessage: ErrorMessageMapper.getMessage(error),
      );
    }
  }

  Future<bool> markOneAsRead(AppNotification notification) async {
    state = state.copyWith(isActionLoading: true, clearError: true);
    try {
      await _repository.markOneAsRead(notification.id);
      state = state.copyWith(
        isActionLoading: false,
        unreadCount: _nextUnreadCount(1),
        important: state.important
            .where((item) => item.id != notification.id)
            .toList(),
        low: state.low.where((item) => item.id != notification.id).toList(),
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: ErrorMessageMapper.getMessage(error),
      );
      return false;
    }
  }

  Future<bool> markLowAsRead() async {
    final removedCount = state.low.length;
    if (removedCount == 0) {
      return true;
    }

    state = state.copyWith(isActionLoading: true, clearError: true);
    try {
      await _repository.markLowAsRead();
      state = state.copyWith(
        isActionLoading: false,
        unreadCount: _nextUnreadCount(removedCount),
        low: const [],
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: ErrorMessageMapper.getMessage(error),
      );
      return false;
    }
  }

  Future<bool> markAllAsRead() async {
    final removedCount = state.important.length + state.low.length;
    if (removedCount == 0) {
      return true;
    }

    state = state.copyWith(isActionLoading: true, clearError: true);
    try {
      await _repository.markAllAsRead();
      state = state.copyWith(
        isActionLoading: false,
        unreadCount: 0,
        important: const [],
        low: const [],
      );
      return true;
    } on AppException catch (error) {
      state = state.copyWith(
        isActionLoading: false,
        errorMessage: ErrorMessageMapper.getMessage(error),
      );
      return false;
    }
  }

  int _nextUnreadCount(int removedCount) {
    final nextCount = state.unreadCount - removedCount;
    return nextCount < 0 ? 0 : nextCount;
  }
}
