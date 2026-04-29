import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet_owner_app/core/errors/app_exception.dart';
import 'package:wallet_owner_app/core/network/api_exception_mapper.dart';
import 'package:wallet_owner_app/core/network/api_result.dart';
import 'package:wallet_owner_app/features/wallets/data/models/wallet_model.dart';
import 'package:wallet_owner_app/features/wallets/data/repositories/app_wallets_repository.dart';
import 'package:wallet_owner_app/features/wallets/data/services/wallets_remote_data_source.dart';

void main() {
  group('ApiExceptionMapper', () {
    const mapper = ApiExceptionMapper();

    test('structured backend error maps correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/wallets'),
        response: Response<Object?>(
          requestOptions: RequestOptions(path: '/wallets'),
          statusCode: 409,
          data: <Object?, Object?>{
            'timestamp': '2026-04-25T10:00:00Z',
            'status': 409,
            'code': 'DUPLICATED_TRANSACTION',
            'message': 'Transaction already exists',
            'path': '/wallets',
            'details': {'externalTransactionId': ['Already used']},
            'traceId': 'trace-123',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final mapped = mapper.map(error);

      expect(
        mapped,
        const AppException(
          code: 'DUPLICATED_TRANSACTION',
          message: 'Transaction already exists',
          status: 409,
          details: {'externalTransactionId': ['Already used']},
          traceId: 'trace-123',
        ),
      );
    });

    test('generic fallback is not used when backend message exists', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/wallets'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/wallets'),
          statusCode: 409,
          data: const {
            'status': 409,
            'code': 'DATA_CONFLICT',
            'message': 'Balance was changed by another operation',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final mapped = mapper.map(error);

      expect(mapped.code, 'DATA_CONFLICT');
      expect(mapped.message, 'Balance was changed by another operation');
    });

    test('network error maps to NETWORK_ERROR', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/wallets'),
        type: DioExceptionType.connectionError,
      );

      final mapped = mapper.map(error);

      expect(mapped.code, 'NETWORK_ERROR');
    });

    test('timeout maps to NETWORK_TIMEOUT', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/wallets'),
        type: DioExceptionType.receiveTimeout,
      );

      final mapped = mapper.map(error);

      expect(mapped.code, 'NETWORK_TIMEOUT');
    });

    test('validation details are preserved', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/wallets'),
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/wallets'),
          statusCode: 422,
          data: const {
            'status': 422,
            'code': 'VALIDATION_ERROR',
            'message': 'Validation failed',
            'details': {
              'username': ['Username is required'],
              'password': ['Password is too short'],
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final mapped = mapper.map(error);

      expect(mapped.code, 'VALIDATION_ERROR');
      expect(
        mapped.details,
        const {
          'username': ['Username is required'],
          'password': ['Password is too short'],
        },
      );
    });
  });

  test('repositories throw AppException, not DioException', () async {
    final repository = AppWalletsRepository(
      remoteDataSource: const _FakeWalletsRemoteDataSource(
        AppException(
          code: 'NETWORK_ERROR',
          message: 'Unable to connect right now.',
        ),
      ),
    );

    await expectLater(
      repository.getWallets(),
      throwsA(allOf(const TypeMatcher<AppException>(), isNot(isA<DioException>()))),
    );
  });
}

class _FakeWalletsRemoteDataSource implements WalletsRemoteDataSource {
  const _FakeWalletsRemoteDataSource(this.exception);

  final AppException exception;

  @override
  Future<ApiResult<WalletModel>> createWallet(CreateWalletRequestModel request) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> deleteWallet(String walletId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<WalletModel>> getWalletById(String walletId) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<WalletModel>>> getWallets() async {
    return ApiError(exception);
  }

  @override
  Future<ApiResult<List<String>>> getWalletTypes() {
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<WalletModel>> updateWallet({
    required String walletId,
    required UpdateWalletRequestModel request,
  }) {
    throw UnimplementedError();
  }
}
