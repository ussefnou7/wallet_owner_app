import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/users_repository.dart';
import '../models/app_user_model.dart';
import '../services/users_remote_data_source.dart';

class AppUsersRepository implements UsersRepository {
  AppUsersRepository({required UsersRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final UsersRemoteDataSource _remoteDataSource;

  @override
  Future<List<AppUser>> getUsers() {
    return _remoteDataSource.getUsers().then(_unwrap);
  }

  @override
  Future<AppUser> createUser(String username, String password) {
    return _remoteDataSource
        .createUser(
          CreateUserRequestModel(username: username, password: password),
        )
        .then(_unwrap);
  }

  @override
  Future<AppUser> updateUser(
    String userId,
    String username,
    String password,
    bool active,
  ) {
    return _remoteDataSource
        .updateUser(
          userId: userId,
          request: UpdateUserRequestModel(
            username: username,
            password: password,
            active: active,
          ),
        )
        .then(_unwrap);
  }

  @override
  Future<void> deleteUser(String userId) {
    return _remoteDataSource.deleteUser(userId).then(_unwrap);
  }

  @override
  Future<AppUser> assignUserToBranch(String userId, String branchId) {
    return _remoteDataSource
        .assignUserToBranch(
          userId: userId,
          request: AssignUserBranchRequestModel(branchId: branchId),
        )
        .then(_unwrap);
  }

  @override
  Future<void> unassignUserFromBranch(String userId) {
    return _remoteDataSource.unassignUserFromBranch(userId).then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw AppFailureException(failure),
    );
  }
}
