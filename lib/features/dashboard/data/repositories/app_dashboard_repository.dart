import '../../../../core/network/api_result.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/dashboard_transaction_summary.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../../domain/entities/user_dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../services/dashboard_remote_data_source.dart';

class AppDashboardRepository implements DashboardRepository {
  const AppDashboardRepository({
    required DashboardRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final DashboardRemoteDataSource _remoteDataSource;

  @override
  Future<DashboardOverview> getOverview() {
    return _remoteDataSource.getOverview().then(_unwrap);
  }

  @override
  Future<OwnerDashboardOverview> getOwnerOverview({
    required DashboardOverviewPeriod period,
  }) {
    return _remoteDataSource.getOwnerOverview(period: period).then(_unwrap);
  }

  @override
  Future<UserDashboardOverview> getUserOverview({
    required DashboardOverviewPeriod period,
  }) {
    return _remoteDataSource.getUserOverview(period: period).then(_unwrap);
  }

  @override
  Future<DashboardTransactionSummary> getTransactionSummary({
    required DateTime fromDate,
    required DateTime toDate,
  }) {
    return _remoteDataSource
        .getTransactionSummary(fromDate: fromDate, toDate: toDate)
        .then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
