import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_response_extractor.dart';
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

  Future<ApiResult<List<String>>> getWalletTypes();
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
      final wallets = ApiResponseExtractor.extractList(response.data)
          .map(WalletModel.fromJson)
          .toList();
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
      return ApiSuccess(
        WalletModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
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
      return ApiSuccess(
        WalletModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
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
      return ApiSuccess(
        WalletModel.fromJson(ApiResponseExtractor.extractObject(response.data)),
      );
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

  @override
  Future<ApiResult<List<String>>> getWalletTypes() async {
    try {
      final response = await _apiClient.get<Object?>(
        '${NetworkConstants.walletsPath}/types',
      );
      final types = ApiResponseExtractor.extractList(response.data)
          .map((item) => (item['name'] as String?) ?? (item as String))
          .toList();
      return ApiSuccess(types);
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }
}
