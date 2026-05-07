import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../reports/domain/entities/report_filters.dart';
import '../../../reports/domain/entities/report_response.dart';
import '../../../reports/domain/entities/report_type.dart';
import '../../../reports/domain/repositories/reports_repository.dart';
import '../../../transactions/domain/entities/recent_transaction.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/dashboard_transaction_summary.dart';
import '../../domain/repositories/dashboard_repository.dart';

final dashboardOverviewProvider = FutureProvider.autoDispose<DashboardOverview>(
  (ref) {
    final session = ref.watch(authenticatedSessionProvider);
    if (session == null) {
      return _emptyDashboardOverview;
    }

    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.getOverview();
  },
);

final userDashboardOverviewProvider =
    FutureProvider.autoDispose<DashboardOverview>((ref) {
      final session = ref.watch(authenticatedSessionProvider);
      if (session == null) {
        return _emptyDashboardOverview;
      }

      final repository = ref.watch(dashboardRepositoryProvider);
      return repository.getOverview();
    });

final dashboardTransactionSummaryProvider =
    FutureProvider.autoDispose<DashboardTransactionSummary>((ref) async {
      final session = ref.watch(authenticatedSessionProvider);
      if (session == null) {
        return _emptyDashboardTransactionSummary;
      }

      final repository = ref.watch(dashboardRepositoryProvider);
      final range = _currentMonthRange();
      return repository.getTransactionSummary(
        fromDate: range.start,
        toDate: range.end,
      );
    });

final dashboardRecentTransactionsProvider =
    FutureProvider.autoDispose<List<RecentTransaction>>((ref) async {
      final session = ref.watch(authenticatedSessionProvider);
      if (session == null) {
        return const <RecentTransaction>[];
      }

      final repository = ref.watch(reportsRepositoryProvider);
      final report = await repository.runReport(
        reportType: ReportType.transactionDetails,
        filters: ReportFilters.empty,
      );

      final rows = _extractRows(report)
        ..sort((first, second) => _rowDate(second).compareTo(_rowDate(first)));

      return rows.take(5).map(_mapRecentTransaction).toList(growable: false);
    });

_DashboardDateRange _currentMonthRange() {
  final now = DateTime.now();

  return _DashboardDateRange(
    start: DateTime(now.year, now.month),
    end: DateTime(
      now.year,
      now.month + 1,
    ).subtract(const Duration(microseconds: 1)),
  );
}

class _DashboardDateRange {
  const _DashboardDateRange({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

List<Map<String, dynamic>> _extractRows(ReportResponse report) {
  final data = report.data;
  if (data is List) {
    return data.whereType<Map>().map(_normalizeMap).toList(growable: false);
  }
  if (data is Map<String, dynamic>) {
    final content = data['content'];
    if (content is List) {
      return content
          .whereType<Map>()
          .map(_normalizeMap)
          .toList(growable: false);
    }
  }
  return const [];
}

Map<String, dynamic> _normalizeMap(Map<dynamic, dynamic> map) {
  return map.map((key, value) => MapEntry('$key', value));
}

RecentTransaction _mapRecentTransaction(Map<String, dynamic> row) {
  final typeValue = '${row['type'] ?? ''}'.toUpperCase();
  return RecentTransaction(
    id:
        row['id'] as String? ??
        row['externalTransactionId'] as String? ??
        row['transactionId'] as String? ??
        '-',
    walletName:
        row['walletName'] as String? ??
        row['walletId'] as String? ??
        'Unknown wallet',
    amount: _asDouble(row['amount']),
    type: typeValue == 'DEBIT' ? TransactionType.debit : TransactionType.credit,
    recordedAt: _parseDate(row['occurredAt'] ?? row['createdAt']),
  );
}

DateTime _rowDate(Map<String, dynamic> row) {
  return _parseDate(
        row['occurredAt'] ??
            row['createdAt'] ??
            row['updatedAt'] ??
            row['date'],
      ) ??
      DateTime.fromMillisecondsSinceEpoch(0);
}

DateTime? _parseDate(Object? value) {
  if (value is String) {
    return DateTime.tryParse(value);
  }
  return null;
}

double _asDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? 0;
  }
  return 0;
}

const _emptyDashboardOverview = DashboardOverview(
  totalBalance: 0,
  activeWallets: 0,
  totalCredits: 0,
  totalDebits: 0,
  netAmount: 0,
  transactionCount: 0,
  metrics: [],
);

const _emptyDashboardTransactionSummary = DashboardTransactionSummary(
  totalCredits: 0,
  totalDebits: 0,
  netAmount: 0,
  transactionCount: 0,
);
