import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/user_performance_filters.dart';
import '../../domain/entities/user_performance_response.dart';
import '../models/user_performance_response_model.dart';

final userPerformanceRemoteDataSourceProvider =
    Provider<UserPerformanceRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      final exceptionMapper = ref.watch(apiExceptionMapperProvider);
      return DioUserPerformanceRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: exceptionMapper,
      );
    });

abstract interface class UserPerformanceRemoteDataSource {
  Future<ApiResult<UserPerformanceResponse>> getUserPerformance({
    required UserPerformanceFilters filters,
  });
}

class DioUserPerformanceRemoteDataSource
    implements UserPerformanceRemoteDataSource {
  DioUserPerformanceRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<UserPerformanceResponse>> getUserPerformance({
    required UserPerformanceFilters filters,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsUsersPerformancePath,
        queryParameters: filters.toQueryParameters(),
      );
      final payload = _extractPayload(response.data);
      return ApiSuccess(UserPerformanceResponseModel.fromJson(payload));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  Map<String, dynamic> _extractPayload(Object? payload) {
    if (payload is Map<String, dynamic>) {
      if (_looksLikePayload(payload)) {
        return payload;
      }

      for (final key in const ['data', 'result', 'item', 'content']) {
        final value = payload[key];
        if (value is Map<String, dynamic>) {
          final nested = _extractPayload(value);
          if (_looksLikePayload(nested)) {
            return nested;
          }
        }
      }
    }

    throw const AppException(
      code: 'UNKNOWN_ERROR',
      message: 'Unexpected user performance response structure.',
    );
  }

  bool _looksLikePayload(Map<String, dynamic> payload) {
    return payload.containsKey('summary') ||
        payload.containsKey('users') ||
        payload.containsKey('totalUserProfit');
  }
}
