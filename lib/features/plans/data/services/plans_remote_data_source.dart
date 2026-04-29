import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../models/plan_model.dart';

final plansRemoteDataSourceProvider = Provider<PlansRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioPlansRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class PlansRemoteDataSource {
  Future<ApiResult<List<PlanModel>>> getPlans();
}

class DioPlansRemoteDataSource implements PlansRemoteDataSource {
  DioPlansRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<PlanModel>>> getPlans() async {
    try {
      final response = await _apiClient.get<Object?>('/api/v1/plans');
      final plans = ApiResponseExtractor.extractList(response.data)
          .map((plan) => PlanModel.fromJson(plan as Map<String, dynamic>))
          .toList();
      return ApiSuccess(plans);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
