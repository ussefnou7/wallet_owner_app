import 'package:equatable/equatable.dart';

class TransactionSummaryFilters extends Equatable {
  const TransactionSummaryFilters({
    this.dateFrom,
    this.dateTo,
    this.walletId,
    this.branchId,
    this.createdBy,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? walletId;
  final String? branchId;
  final String? createdBy;

  factory TransactionSummaryFilters.currentMonth() {
    final now = DateTime.now();
    return TransactionSummaryFilters(
      dateFrom: DateTime(now.year, now.month, 1),
      dateTo: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  bool get hasScopedFilters =>
      _hasText(walletId) || _hasText(branchId) || _hasText(createdBy);

  int get scopedFiltersCount {
    var count = 0;
    if (_hasText(walletId)) {
      count += 1;
    }
    if (_hasText(branchId)) {
      count += 1;
    }
    if (_hasText(createdBy)) {
      count += 1;
    }
    return count;
  }

  TransactionSummaryFilters copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? walletId,
    String? branchId,
    String? createdBy,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearWalletId = false,
    bool clearBranchId = false,
    bool clearCreatedBy = false,
  }) {
    return TransactionSummaryFilters(
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      walletId: clearWalletId ? null : walletId ?? this.walletId,
      branchId: clearBranchId ? null : branchId ?? this.branchId,
      createdBy: clearCreatedBy ? null : createdBy ?? this.createdBy,
    );
  }

  TransactionSummaryFilters clearAll() {
    return TransactionSummaryFilters.currentMonth();
  }

  TransactionSummaryFilters normalized() {
    final normalizedFrom = dateFrom == null ? null : _startOfDay(dateFrom!);
    final normalizedTo = dateTo == null ? null : _endOfDay(dateTo!);

    return TransactionSummaryFilters(
      dateFrom: normalizedFrom,
      dateTo: normalizedTo,
      walletId: _clean(walletId),
      branchId: _clean(branchId),
      createdBy: _clean(createdBy),
    );
  }

  Map<String, dynamic> toQueryParameters() {
    final normalizedFilters = normalized();
    return {
      if (normalizedFilters.dateFrom != null)
        'dateFrom': normalizedFilters.dateFrom!.toIso8601String(),
      if (normalizedFilters.dateTo != null)
        'dateTo': normalizedFilters.dateTo!.toIso8601String(),
      if (_hasText(normalizedFilters.walletId))
        'walletId': normalizedFilters.walletId,
      if (_hasText(normalizedFilters.branchId))
        'branchId': normalizedFilters.branchId,
      if (_hasText(normalizedFilters.createdBy))
        'createdBy': normalizedFilters.createdBy,
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
  List<Object?> get props => [dateFrom, dateTo, walletId, branchId, createdBy];
}
