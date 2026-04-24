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
}
