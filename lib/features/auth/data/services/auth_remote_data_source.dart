import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/session.dart';
import '../models/forgot_password_request_model.dart';
import '../models/forgot_password_response_model.dart';
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

  Future<ApiResult<Session>> getCurrentSession(Session currentSession);

  Future<ApiResult<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  );

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });
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

      ApiResponseExtractor.validateNotEmpty(response.data);
      return ApiSuccess(LoginResponseModel.fromJson(response.data!));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<Session>> getCurrentSession(Session currentSession) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.authMePath,
      );

      ApiResponseExtractor.validateNotEmpty(response.data);
      final payload = ApiResponseExtractor.extractObject(response.data);
      return ApiSuccess(
        Session.fromApiPayload(
          payload,
          accessToken: currentSession.accessToken,
          refreshToken: currentSession.refreshToken,
          fallbackSession: currentSession,
          tokenExpiresAt: currentSession.tokenExpiresAt,
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<ForgotPasswordResponseModel>> forgotPassword(
    ForgotPasswordRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        NetworkConstants.authForgotPasswordPath,
        data: request.toJson(),
      );

      ApiResponseExtractor.validateNotEmpty(response.data);
      return ApiSuccess(ForgotPasswordResponseModel.fromJson(response.data!));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.patch<void>(
        NetworkConstants.mePasswordPath,
        data: {'oldPassword': currentPassword, 'newPassword': newPassword},
      );
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
