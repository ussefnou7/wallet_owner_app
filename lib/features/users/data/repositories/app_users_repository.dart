import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../services/users_remote_data_source.dart';

class AppUsersRepository implements UsersRepository {
  AppUsersRepository({required UsersRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<List<AppUser>> getUsers() {
    return _remoteDataSource.getUsers().then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw AppFailureException(failure),
    );
  }
}
