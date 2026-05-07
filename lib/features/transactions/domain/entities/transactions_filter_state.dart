import 'package:equatable/equatable.dart';

import 'transaction_draft.dart';

class TransactionsFilterState extends Equatable {
  const TransactionsFilterState({
    this.walletId,
    this.branchId,
    this.type,
    this.dateFrom,
    this.dateTo,
    this.createdBy,
    this.page = 0,
    this.size = 20,
  });

  final String? walletId;
  final String? branchId;
  final TransactionEntryType? type;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? createdBy;
  final int page;
  final int size;

  bool get hasActiveFilters =>
      _hasText(walletId) ||
      _hasText(branchId) ||
      dateFrom != null ||
      dateTo != null ||
      _hasText(createdBy);

  int get activeFiltersCount {
    var count = 0;
    if (_hasText(walletId)) {
      count += 1;
    }
    if (_hasText(branchId)) {
      count += 1;
    }
    if (dateFrom != null || dateTo != null) {
      count += 1;
    }
    if (_hasText(createdBy)) {
      count += 1;
    }
    return count;
  }

  TransactionsFilterState copyWith({
    String? walletId,
    String? branchId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    String? createdBy,
    int? page,
    int? size,
    bool clearWalletId = false,
    bool clearBranchId = false,
    bool clearType = false,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearCreatedBy = false,
  }) {
    return TransactionsFilterState(
      walletId: clearWalletId ? null : walletId ?? this.walletId,
      branchId: clearBranchId ? null : branchId ?? this.branchId,
      type: clearType ? null : type ?? this.type,
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      createdBy: clearCreatedBy ? null : createdBy ?? this.createdBy,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  TransactionsFilterState clearAll({TransactionEntryType? type}) {
    return TransactionsFilterState(type: type, page: 0, size: size);
  }

  Map<String, dynamic> toQueryParameters({bool includeCreatedBy = true}) {
    return {
      'page': page,
      'size': size,
      if (_hasText(walletId)) 'walletId': walletId,
      if (_hasText(branchId)) 'branchId': branchId,
      if (type != null && type != TransactionEntryType.unknown)
        'type': _typeToJson(type!),
      if (dateFrom != null)
        'dateFrom': _startOfDay(dateFrom!).toIso8601String(),
      if (dateTo != null) 'dateTo': _endOfDay(dateTo!).toIso8601String(),
      if (includeCreatedBy && _hasText(createdBy)) 'createdBy': createdBy,
    };
  }

  static String _typeToJson(TransactionEntryType type) {
    return switch (type) {
      TransactionEntryType.credit => 'CREDIT',
      TransactionEntryType.debit => 'DEBIT',
      TransactionEntryType.unknown => 'UNKNOWN',
    };
  }

  static DateTime _startOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day);
  }

  static DateTime _endOfDay(DateTime value) {
    return DateTime(value.year, value.month, value.day, 23, 59, 59);
  }

  static bool _hasText(String? value) =>
      value != null && value.trim().isNotEmpty;

  @override
  List<Object?> get props => [
    walletId,
    branchId,
    type,
    dateFrom,
    dateTo,
    createdBy,
    page,
    size,
  ];
}
