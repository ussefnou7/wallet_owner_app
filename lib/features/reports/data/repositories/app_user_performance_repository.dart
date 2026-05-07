import '../../../../core/network/api_result.dart';
import '../../domain/entities/user_performance_filters.dart';
import '../../domain/entities/user_performance_response.dart';
import '../../domain/repositories/user_performance_repository.dart';
import '../services/user_performance_remote_data_source.dart';

class AppUserPerformanceRepository implements UserPerformanceRepository {
  AppUserPerformanceRepository({
    required UserPerformanceRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final UserPerformanceRemoteDataSource _remoteDataSource;

  @override
  Future<UserPerformanceResponse> getUserPerformance({
    required UserPerformanceFilters filters,
  }) {
    return _remoteDataSource.getUserPerformance(filters: filters).then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
