import '../../../../core/network/api_result.dart';
import '../../domain/entities/profit_summary_filters.dart';
import '../../domain/entities/profit_summary_response.dart';
import '../../domain/repositories/profit_summary_repository.dart';
import '../services/profit_summary_remote_data_source.dart';

class AppProfitSummaryRepository implements ProfitSummaryRepository {
  AppProfitSummaryRepository({
    required ProfitSummaryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final ProfitSummaryRemoteDataSource _remoteDataSource;

  @override
  Future<ProfitSummaryResponse> getProfitSummary({
    required ProfitSummaryFilters filters,
  }) {
    return _remoteDataSource.getProfitSummary(filters: filters).then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
