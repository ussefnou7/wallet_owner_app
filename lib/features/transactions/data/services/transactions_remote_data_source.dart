import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/models/paged_response.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/transaction_draft.dart';
import '../models/transaction_draft_model.dart';
import '../models/transaction_record_model.dart';

final transactionsRemoteDataSourceProvider =
    Provider<TransactionsRemoteDataSource>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      final exceptionMapper = ref.watch(apiExceptionMapperProvider);
      return DioTransactionsRemoteDataSource(
        apiClient: apiClient,
        exceptionMapper: exceptionMapper,
      );
    });

abstract interface class TransactionsRemoteDataSource {
  Future<ApiResult<PagedResponse<TransactionRecordModel>>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 0,
    int size = 20,
  });

  Future<ApiResult<TransactionRecordModel>> getTransactionById(
    String transactionId,
  );

  Future<ApiResult<TransactionRecordModel>> createTransaction(
    TransactionDraftModel request,
  );
}

class DioTransactionsRemoteDataSource implements TransactionsRemoteDataSource {
  DioTransactionsRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<PagedResponse<TransactionRecordModel>>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
    int page = 0,
    int size = 20,
  }) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        NetworkConstants.transactionsPath,
        queryParameters: {
          'page': page,
          'size': size,
          if (walletId != null && walletId.isNotEmpty) 'walletId': walletId,
          if (type != null && type != TransactionEntryType.unknown)
            'type': _typeToJson(type),
          if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
          if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
        },
      );
      final payload = response.data;
      if (payload == null) {
        throw const AppException(
          code: 'UNKNOWN_ERROR',
          message: 'Server returned empty response.',
        );
      }

      return ApiSuccess(
        PagedResponse<TransactionRecordModel>.fromJson(
          payload,
          TransactionRecordModel.fromJson,
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<TransactionRecordModel>> getTransactionById(
    String transactionId,
  ) async {
    try {
      final response = await _apiClient.get<Object?>(
        '${NetworkConstants.transactionsPath}/$transactionId',
      );
      return ApiSuccess(
        TransactionRecordModel.fromJson(
          ApiResponseExtractor.extractObject(response.data),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<TransactionRecordModel>> createTransaction(
    TransactionDraftModel request,
  ) async {
    try {
      final response = await _apiClient.post<Object?>(
        NetworkConstants.transactionsPath,
        data: request.toJson(),
      );
      return ApiSuccess(
        TransactionRecordModel.fromJson(
          ApiResponseExtractor.extractObject(response.data),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  String _typeToJson(TransactionEntryType type) {
    return switch (type) {
      TransactionEntryType.credit => 'CREDIT',
      TransactionEntryType.debit => 'DEBIT',
      TransactionEntryType.unknown => 'UNKNOWN',
    };
  }
}
