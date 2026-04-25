import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/app_user_model.dart';

final usersRemoteDataSourceProvider = Provider<UsersRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioUsersRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class UsersRemoteDataSource {
  Future<ApiResult<List<AppUserModel>>> getUsers();

  Future<ApiResult<AppUserModel>> createUser(CreateUserRequestModel request);

  Future<ApiResult<AppUserModel>> updateUser({
    required String userId,
    required UpdateUserRequestModel request,
  });

  Future<ApiResult<void>> deleteUser(String userId);

  Future<ApiResult<AppUserModel>> assignUserToBranch({
    required String userId,
    required AssignUserBranchRequestModel request,
  });

  Future<ApiResult<void>> unassignUserFromBranch(String userId);
}

class DioUsersRemoteDataSource implements UsersRemoteDataSource {
  DioUsersRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<AppUserModel>>> getUsers() async {
    try {
      final response = await _apiClient.get<Object?>(NetworkConstants.usersPath);
      final users = ApiResponseExtractor.extractList(
        response.data,
      ).map(AppUserModel.fromJson).toList();
      return ApiSuccess(users);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<AppUserModel>> createUser(
    CreateUserRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post<Object?>(
        NetworkConstants.usersPath,
        data: request.toJson(),
      );
      return ApiSuccess(
        AppUserModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<AppUserModel>> updateUser({
    required String userId,
    required UpdateUserRequestModel request,
  }) async {
    try {
      final response = await _apiClient.put<Object?>(
        NetworkConstants.userPath(userId),
        data: request.toJson(),
      );
      return ApiSuccess(
        AppUserModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteUser(String userId) async {
    try {
      await _apiClient.delete<Object?>(NetworkConstants.userPath(userId));
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<AppUserModel>> assignUserToBranch({
    required String userId,
    required AssignUserBranchRequestModel request,
  }) async {
    try {
      final response = await _apiClient.put<Object?>(
        NetworkConstants.userBranchAssignmentPath(userId),
        data: request.toJson(),
      );
      return ApiSuccess(
        AppUserModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> unassignUserFromBranch(String userId) async {
    try {
      await _apiClient.delete<Object?>(
        NetworkConstants.userBranchAssignmentPath(userId),
      );
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
