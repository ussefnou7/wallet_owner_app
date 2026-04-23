import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../models/wallet_model.dart';

final walletsRemoteDataSourceProvider = Provider<WalletsRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioWalletsRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class WalletsRemoteDataSource {
  Future<ApiResult<List<WalletModel>>> getWallets();

  Future<ApiResult<WalletModel>> getWalletById(String walletId);

  Future<ApiResult<WalletModel>> createWallet(CreateWalletRequestModel request);

  Future<ApiResult<WalletModel>> updateWallet({
    required String walletId,
    required UpdateWalletRequestModel request,
  });

  Future<ApiResult<void>> deleteWallet(String walletId);
}

class DioWalletsRemoteDataSource implements WalletsRemoteDataSource {
  DioWalletsRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<List<WalletModel>>> getWallets() async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.walletsPath,
      );
      final wallets = _extractList(
        response.data,
      ).map(WalletModel.fromJson).toList();
      return ApiSuccess(wallets);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<WalletModel>> getWalletById(String walletId) async {
    try {
      final response = await _apiClient.get<Object?>(
        '${NetworkConstants.walletsPath}/$walletId',
      );
      return ApiSuccess(WalletModel.fromJson(_extractObject(response.data)));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<WalletModel>> createWallet(
    CreateWalletRequestModel request,
  ) async {
    try {
      final response = await _apiClient.post<Object?>(
        NetworkConstants.walletsPath,
        data: request.toJson(),
      );
      return ApiSuccess(WalletModel.fromJson(_extractObject(response.data)));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<WalletModel>> updateWallet({
    required String walletId,
    required UpdateWalletRequestModel request,
  }) async {
    try {
      final response = await _apiClient.put<Object?>(
        '${NetworkConstants.walletsPath}/$walletId',
        data: request.toJson(),
      );
      return ApiSuccess(WalletModel.fromJson(_extractObject(response.data)));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<void>> deleteWallet(String walletId) async {
    try {
      await _apiClient.delete<Object?>(
        '${NetworkConstants.walletsPath}/$walletId',
      );
      return const ApiSuccess(null);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  List<Map<String, dynamic>> _extractList(Object? payload) {
    final listPayload = switch (payload) {
      final List<Object?> value => value,
      final Map<String, dynamic> value => _wrappedList(value),
      _ => null,
    };

    if (listPayload == null) {
      throw const AppFailureException(
        UnknownFailure('Unexpected wallets response received from the server.'),
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
      UnknownFailure('Unexpected wallet response received from the server.'),
    );
  }
}
