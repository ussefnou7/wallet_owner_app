import 'package:equatable/equatable.dart';

import 'report_type.dart';

class ReportFilters extends Equatable {
  const ReportFilters({
    this.fromDate,
    this.toDate,
    this.branchId,
    this.walletId,
    this.type,
    this.active,
    this.period,
    this.createdBy,
  });

  final DateTime? fromDate;
  final DateTime? toDate;
  final String? branchId;
  final String? walletId;
  final String? type;
  final bool? active;
  final String? period;
  final String? createdBy;

  static const empty = ReportFilters();

  ReportFilters copyWith({
    DateTime? fromDate,
    DateTime? toDate,
    String? branchId,
    String? walletId,
    String? type,
    bool? active,
    String? period,
    String? createdBy,
    bool clearFromDate = false,
    bool clearToDate = false,
    bool clearBranchId = false,
    bool clearWalletId = false,
    bool clearType = false,
    bool clearActive = false,
    bool clearPeriod = false,
    bool clearCreatedBy = false,
  }) {
    return ReportFilters(
      fromDate: clearFromDate ? null : fromDate ?? this.fromDate,
      toDate: clearToDate ? null : toDate ?? this.toDate,
      branchId: clearBranchId ? null : branchId ?? this.branchId,
      walletId: clearWalletId ? null : walletId ?? this.walletId,
      type: clearType ? null : type ?? this.type,
      active: clearActive ? null : active ?? this.active,
      period: clearPeriod ? null : period ?? this.period,
      createdBy: clearCreatedBy ? null : createdBy ?? this.createdBy,
    );
  }

  ReportFilters sanitizedFor(ReportType reportType) {
    return ReportFilters(
      fromDate: reportType.supportedFilters.contains(ReportFilterField.fromDate)
          ? fromDate
          : null,
      toDate: reportType.supportedFilters.contains(ReportFilterField.toDate)
          ? toDate
          : null,
      branchId: reportType.supportedFilters.contains(ReportFilterField.branchId)
          ? _clean(branchId)
          : null,
      walletId: reportType.supportedFilters.contains(ReportFilterField.walletId)
          ? _clean(walletId)
          : null,
      type: reportType.supportedFilters.contains(ReportFilterField.type)
          ? _clean(type)
          : null,
      active: reportType.supportedFilters.contains(ReportFilterField.active)
          ? active
          : null,
      period: reportType.supportedFilters.contains(ReportFilterField.period)
          ? _clean(period) ??
                (reportType == ReportType.transactionTimeAggregation
                    ? 'DAILY'
                    : null)
          : null,
      createdBy:
          reportType.supportedFilters.contains(ReportFilterField.createdBy)
          ? _clean(createdBy)
          : null,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      if (fromDate != null) 'fromDate': fromDate!.toIso8601String(),
      if (toDate != null) 'toDate': toDate!.toIso8601String(),
      if (_clean(branchId) != null) 'branchId': _clean(branchId),
      if (_clean(walletId) != null) 'walletId': _clean(walletId),
      if (_clean(type) != null) 'type': _clean(type),
      if (active != null) 'active': active,
      if (_clean(period) != null) 'period': _clean(period),
      if (_clean(createdBy) != null) 'createdBy': _clean(createdBy),
    };
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
    fromDate,
    toDate,
    branchId,
    walletId,
    type,
    active,
    period,
    createdBy,
  ];
}
