import '../../domain/entities/branch.dart';
import '../../domain/repositories/branches_repository.dart';
import '../services/branches_remote_data_source.dart';

class AppBranchesRepository implements BranchesRepository {
  const AppBranchesRepository({required BranchesRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  final BranchesRemoteDataSource _remoteDataSource;

  @override
  Future<List<Branch>> getBranches() async {
    final result = await _remoteDataSource.getBranches();
    return result.when(
      success: (branches) => branches.cast<Branch>(),
      failure: (_) => throw Exception('Failed to load branches'),
    );
  }
}
