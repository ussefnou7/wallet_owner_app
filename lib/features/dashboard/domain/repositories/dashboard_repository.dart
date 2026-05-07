import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/dashboard_overview.dart';
import '../entities/dashboard_transaction_summary.dart';
import '../entities/owner_dashboard_overview.dart';
import '../entities/user_dashboard_overview.dart';

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  throw UnimplementedError(
    'dashboardRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class DashboardRepository {
  Future<DashboardOverview> getOverview();

  Future<OwnerDashboardOverview> getOwnerOverview({
    required DashboardOverviewPeriod period,
  });

  Future<UserDashboardOverview> getUserOverview({
    required DashboardOverviewPeriod period,
  });

  Future<DashboardTransactionSummary> getTransactionSummary({
    required DateTime fromDate,
    required DateTime toDate,
  });
}
