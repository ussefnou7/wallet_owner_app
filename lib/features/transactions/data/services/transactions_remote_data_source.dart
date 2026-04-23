import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
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
  Future<ApiResult<List<TransactionRecordModel>>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
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
  Future<ApiResult<List<TransactionRecordModel>>> getTransactions({
    String? walletId,
    TransactionEntryType? type,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.transactionsPath,
        queryParameters: {
          if (walletId != null && walletId.isNotEmpty) 'walletId': walletId,
          if (type != null && type != TransactionEntryType.unknown)
            'type': _typeToJson(type),
          if (dateFrom != null) 'dateFrom': dateFrom.toIso8601String(),
          if (dateTo != null) 'dateTo': dateTo.toIso8601String(),
        },
      );
      final transactions = _extractList(
        response.data,
      ).map(TransactionRecordModel.fromJson).toList();
      return ApiSuccess(transactions);
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
        TransactionRecordModel.fromJson(_extractObject(response.data)),
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
        TransactionRecordModel.fromJson(_extractObject(response.data)),
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

  List<Map<String, dynamic>> _extractList(Object? payload) {
    final listPayload = switch (payload) {
      final List<Object?> value => value,
      final Map<String, dynamic> value => _wrappedList(value),
      _ => null,
    };

    if (listPayload == null) {
      throw const AppFailureException(
        UnknownFailure(
          'Unexpected transactions response received from the server.',
        ),
      );
    }

    return listPayload.whereType<Map<String, dynamic>>().toList();
  }

  List<Object?>? _wrappedList(Map<String, dynamic> payload) {
    for (final key in const ['data', 'content', 'items', 'results']) {
      final value = payload[key];
      if (value is List<Object?>) {
        return value;
      }
      if (value is Map<String, dynamic>) {
        final nested = _wrappedList(value);
        if (nested != null) {
          return nested;
        }
      }
    }

    return null;
  }

  Map<String, dynamic> _extractObject(Object? payload) {
    if (payload is Map<String, dynamic>) {
      for (final key in const ['data', 'content', 'item', 'result']) {
        final value = payload[key];
        if (value is Map<String, dynamic>) {
          return _extractObject(value);
        }
      }

      return payload;
    }

    throw const AppFailureException(
      UnknownFailure(
        'Unexpected transaction response received from the server.',
      ),
    );
  }
}
