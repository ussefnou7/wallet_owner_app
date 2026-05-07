import 'package:equatable/equatable.dart';

class ProfitSummaryFilters extends Equatable {
  const ProfitSummaryFilters({
    this.dateFrom,
    this.dateTo,
    this.branchId,
    this.walletId,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? branchId;
  final String? walletId;

  factory ProfitSummaryFilters.currentMonth() {
    final now = DateTime.now();
    return ProfitSummaryFilters(
      dateFrom: DateTime(now.year, now.month, 1),
      dateTo: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  bool get hasScopedFilters => _hasText(branchId) || _hasText(walletId);

  int get scopedFiltersCount {
    var count = 0;
    if (_hasText(branchId)) {
      count += 1;
    }
    if (_hasText(walletId)) {
      count += 1;
    }
    return count;
  }

  ProfitSummaryFilters copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? branchId,
    String? walletId,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearBranchId = false,
    bool clearWalletId = false,
  }) {
    return ProfitSummaryFilters(
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      branchId: clearBranchId ? null : branchId ?? this.branchId,
      walletId: clearWalletId ? null : walletId ?? this.walletId,
    );
  }

  ProfitSummaryFilters clearAll() {
    return ProfitSummaryFilters.currentMonth();
  }

  ProfitSummaryFilters normalized() {
    final normalizedFrom = dateFrom == null ? null : _startOfDay(dateFrom!);
    final normalizedTo = dateTo == null ? null : _endOfDay(dateTo!);

    return ProfitSummaryFilters(
      dateFrom: normalizedFrom,
      dateTo: normalizedTo,
      branchId: _clean(branchId),
      walletId: _clean(walletId),
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final normalizedFilters = normalized();
    return {
      if (normalizedFilters.dateFrom != null)
        'dateFrom': normalizedFilters.dateFrom!.toIso8601String(),
      if (normalizedFilters.dateTo != null)
        'dateTo': normalizedFilters.dateTo!.toIso8601String(),
      if (_hasText(normalizedFilters.branchId))
        'branchId': normalizedFilters.branchId,
      if (_hasText(normalizedFilters.walletId))
        'walletId': normalizedFilters.walletId,
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
  List<Object?> get props => [dateFrom, dateTo, branchId, walletId];
}
