import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/transaction_summary_filters.dart';
import '../../domain/entities/transaction_summary_response.dart';
import '../models/transaction_summary_response_model.dart';

final transactionSummaryRemoteDataSourceProvider =
    Provider<TransactionSummaryRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      final exceptionMapper = ref.watch(apiExceptionMapperProvider);
      return DioTransactionSummaryRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: exceptionMapper,
      );
    });

abstract interface class TransactionSummaryRemoteDataSource {
  Future<ApiResult<TransactionSummaryResponse>> getTransactionSummary({
    required TransactionSummaryFilters filters,
  });
}

class DioTransactionSummaryRemoteDataSource
    implements TransactionSummaryRemoteDataSource {
  DioTransactionSummaryRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<TransactionSummaryResponse>> getTransactionSummary({
    required TransactionSummaryFilters filters,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsTransactionsSummaryPath,
        queryParameters: filters.toQueryParameters(),
      );
      final payload = _extractPayload(response.data);
      return ApiSuccess(TransactionSummaryResponseModel.fromJson(payload));
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
      message: 'Unexpected transaction summary response structure.',
    );
  }

  bool _looksLikePayload(Map<String, dynamic> payload) {
    return payload.containsKey('summary') ||
        payload.containsKey('highestTransaction') ||
        payload.containsKey('totalCredits');
  }
}
