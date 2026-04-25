import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/branch_model.dart';

final branchesRemoteDataSourceProvider = Provider<BranchesRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioBranchesRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class BranchesRemoteDataSource {
  Future<ApiResult<List<BranchModel>>> getBranches();

  Future<ApiResult<BranchModel>> createBranch(CreateBranchRequestModel request);

  Future<ApiResult<BranchModel>> updateBranch({
    required String branchId,
    required UpdateBranchRequestModel request,
  });

  Future<ApiResult<void>> deleteBranch(String branchId);
}

class DioBranchesRemoteDataSource implements BranchesRemoteDataSource {
  DioBranchesRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<BranchModel>>> getBranches() async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.branchesPath,
      );
      final branches = ApiResponseExtractor.extractList(response.data)
          .map(BranchModel.fromJson)
          .toList();
      return ApiSuccess(branches);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<BranchModel>> createBranch(
    CreateBranchRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post<Object?>(
        NetworkConstants.branchesPath,
        data: request.toJson(),
      );
      return ApiSuccess(
        BranchModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<BranchModel>> updateBranch({
    required String branchId,
    required UpdateBranchRequestModel request,
  }) async {
    try {
      final response = await _apiClient.put<Object?>(
        NetworkConstants.branchPath(branchId),
        data: request.toJson(),
      );
      return ApiSuccess(
        BranchModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteBranch(String branchId) async {
    try {
      await _apiClient.delete<Object?>(NetworkConstants.branchPath(branchId));
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
