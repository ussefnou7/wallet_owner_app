import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/branch.dart';
import '../../domain/repositories/branches_repository.dart';
import '../models/branch_model.dart';
import '../services/branches_remote_data_source.dart';

class AppBranchesRepository implements BranchesRepository {
  const AppBranchesRepository({required BranchesRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final BranchesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Branch>> getBranches() => _remoteDataSource.getBranches().then(_unwrap);

  @override
  Future<Branch> createBranch(String name) {
    return _remoteDataSource
        .createBranch(CreateBranchRequestModel(name: name))
        .then(_unwrap);
  }

  @override
  Future<Branch> updateBranch(String branchId, String name, bool active) {
    return _remoteDataSource
        .updateBranch(
          branchId: branchId,
          request: UpdateBranchRequestModel(name: name, active: active),
        )
        .then(_unwrap);
  }

  @override
  Future<void> deleteBranch(String branchId) {
    return _remoteDataSource.deleteBranch(branchId).then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw AppFailureException(failure),
    );
  }
}
