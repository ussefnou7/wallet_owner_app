import 'package:equatable/equatable.dart';

class UserPerformanceFilters extends Equatable {
  const UserPerformanceFilters({
    this.dateFrom,
    this.dateTo,
    this.userId,
    this.walletId,
    this.branchId,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? userId;
  final String? walletId;
  final String? branchId;

  factory UserPerformanceFilters.currentMonth() {
    final now = DateTime.now();
    return UserPerformanceFilters(
      dateFrom: DateTime(now.year, now.month, 1),
      dateTo: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  UserPerformanceFilters normalized() {
    return UserPerformanceFilters(
      dateFrom: dateFrom == null ? null : _startOfDay(dateFrom!),
      dateTo: dateTo == null ? null : _endOfDay(dateTo!),
      userId: _clean(userId),
      walletId: _clean(walletId),
      branchId: _clean(branchId),
    );
  }

  UserPerformanceFilters clearAll() => UserPerformanceFilters.currentMonth();

  Map<String, dynamic> toQueryParameters() {
    final normalizedFilters = normalized();
    return {
      if (normalizedFilters.dateFrom != null)
        'dateFrom': normalizedFilters.dateFrom!.toIso8601String(),
      if (normalizedFilters.dateTo != null)
        'dateTo': normalizedFilters.dateTo!.toIso8601String(),
      if (_hasText(normalizedFilters.userId))
        'userId': normalizedFilters.userId,
      if (_hasText(normalizedFilters.walletId))
        'walletId': normalizedFilters.walletId,
      if (_hasText(normalizedFilters.branchId))
        'branchId': normalizedFilters.branchId,
    };
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59);
  }

  static String? _clean(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static bool _hasText(String? value) => _clean(value) != null;

  @override
  List<Object?> get props => [dateFrom, dateTo, userId, walletId, branchId];
}
