import '../../../../core/network/api_result.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/entities/report_response.dart';
import '../../domain/entities/report_type.dart';
import '../../domain/repositories/reports_repository.dart';
import '../services/reports_remote_data_source.dart';

class AppReportsRepository implements ReportsRepository {
  AppReportsRepository({required ReportsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final ReportsRemoteDataSource _remoteDataSource;

  @override
  Future<ReportResponse> runReport({
    required ReportType reportType,
    required ReportFilters filters,
  }) {
    return _remoteDataSource
        .runReport(reportType: reportType, filters: filters)
        .then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
