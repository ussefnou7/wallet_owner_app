import '../../../../core/network/api_result.dart';
import '../../domain/entities/plan.dart';
import '../../domain/repositories/plans_repository.dart';
import '../services/plans_remote_data_source.dart';

class AppPlansRepository implements PlansRepository {
  AppPlansRepository({required PlansRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final PlansRemoteDataSource _remoteDataSource;

  @override
  Future<List<Plan>> getPlans() {
    return _remoteDataSource.getPlans().then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
