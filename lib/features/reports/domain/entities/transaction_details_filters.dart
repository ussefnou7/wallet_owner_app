import 'package:equatable/equatable.dart';

import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../../transactions/domain/entities/transactions_filter_state.dart';

class TransactionDetailsFilters extends Equatable {
  const TransactionDetailsFilters({
    this.dateFrom,
    this.dateTo,
    this.walletId,
    this.branchId,
    this.createdBy,
    this.type,
    this.page = 0,
    this.size = 20,
  });

  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? walletId;
  final String? branchId;
  final String? createdBy;
  final TransactionEntryType? type;
  final int page;
  final int size;

  factory TransactionDetailsFilters.currentMonth() {
    final now = DateTime.now();
    return TransactionDetailsFilters(
      dateFrom: DateTime(now.year, now.month, 1),
      dateTo: DateTime(now.year, now.month, now.day, 23, 59, 59),
    );
  }

  TransactionDetailsFilters copyWith({
    DateTime? dateFrom,
    DateTime? dateTo,
    String? walletId,
    String? branchId,
    String? createdBy,
    TransactionEntryType? type,
    int? page,
    int? size,
    bool clearDateFrom = false,
    bool clearDateTo = false,
    bool clearWalletId = false,
    bool clearBranchId = false,
    bool clearCreatedBy = false,
    bool clearType = false,
  }) {
    return TransactionDetailsFilters(
      dateFrom: clearDateFrom ? null : dateFrom ?? this.dateFrom,
      dateTo: clearDateTo ? null : dateTo ?? this.dateTo,
      walletId: clearWalletId ? null : walletId ?? this.walletId,
      branchId: clearBranchId ? null : branchId ?? this.branchId,
      createdBy: clearCreatedBy ? null : createdBy ?? this.createdBy,
      type: clearType ? null : type ?? this.type,
      page: page ?? this.page,
      size: size ?? this.size,
    );
  }

  TransactionDetailsFilters clearAll() {
    return TransactionDetailsFilters.currentMonth().copyWith(size: size);
  }

  TransactionDetailsFilters normalized() {
    return TransactionDetailsFilters(
      dateFrom: dateFrom == null ? null : _startOfDay(dateFrom!),
      dateTo: dateTo == null ? null : _endOfDay(dateTo!),
      walletId: _clean(walletId),
      branchId: _clean(branchId),
      createdBy: _clean(createdBy),
      type: type == TransactionEntryType.unknown ? null : type,
      page: page < 0 ? 0 : page,
      size: size <= 0 ? 20 : size,
    );
  }

  TransactionsFilterState toTransactionsFilterState() {
    final normalizedFilters = normalized();
    return TransactionsFilterState(
      walletId: normalizedFilters.walletId,
      branchId: normalizedFilters.branchId,
      createdBy: normalizedFilters.createdBy,
      type: normalizedFilters.type,
      dateFrom: normalizedFilters.dateFrom,
      dateTo: normalizedFilters.dateTo,
      page: normalizedFilters.page,
      size: normalizedFilters.size,
    );
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

  @override
  List<Object?> get props => [
    dateFrom,
    dateTo,
    walletId,
    branchId,
    createdBy,
    type,
    page,
    size,
  ];
}
