import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/profit_summary_filters.dart';
import '../../domain/entities/profit_summary_response.dart';
import '../models/profit_summary_response_model.dart';

final profitSummaryRemoteDataSourceProvider =
    Provider<ProfitSummaryRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      final exceptionMapper = ref.watch(apiExceptionMapperProvider);
      return DioProfitSummaryRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: exceptionMapper,
      );
    });

abstract interface class ProfitSummaryRemoteDataSource {
  Future<ApiResult<ProfitSummaryResponse>> getProfitSummary({
    required ProfitSummaryFilters filters,
  });
}

class DioProfitSummaryRemoteDataSource
    implements ProfitSummaryRemoteDataSource {
  DioProfitSummaryRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<ProfitSummaryResponse>> getProfitSummary({
    required ProfitSummaryFilters filters,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsWalletsProfitSummaryPath,
        queryParameters: filters.toQueryParameters(),
      );
      final payload = _extractPayload(response.data);
      return ApiSuccess(ProfitSummaryResponseModel.fromJson(payload));
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
      message: 'Unexpected profit summary response structure.',
    );
  }

  bool _looksLikePayload(Map<String, dynamic> payload) {
    return payload.containsKey('summary') ||
        payload.containsKey('totalProfits') ||
        payload.containsKey('totalCollectedProfit');
  }
}
