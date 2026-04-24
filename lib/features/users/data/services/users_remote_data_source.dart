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
}
