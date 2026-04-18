import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioAuthRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class AuthRemoteDataSource {
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request);
}

class DioAuthRemoteDataSource implements AuthRemoteDataSource {
  DioAuthRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<LoginResponseModel>> login(LoginRequestModel request) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        NetworkConstants.authLoginPath,
        data: request.toJson(),
      );
      final payload = response.data;
      if (payload == null) {
        return const ApiError(
          UnknownFailure('Empty response received from the server.'),
        );
      }

      return ApiSuccess(LoginResponseModel.fromJson(payload));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
