import '../../../../core/network/api_result.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';
import '../models/wallet_model.dart';
import '../services/wallets_remote_data_source.dart';

class AppWalletsRepository implements WalletsRepository {
  AppWalletsRepository({required WalletsRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final WalletsRemoteDataSource _remoteDataSource;

  @override
  Future<List<Wallet>> getWallets() {
    return _remoteDataSource.getWallets().then(_unwrap);
  }

  @override
  Future<Wallet> getWalletById(String walletId) {
    return _remoteDataSource.getWalletById(walletId).then(_unwrap);
  }

  @override
  Future<Wallet> createWallet({
    required String name,
    required String number,
    required String branchId,
    required double balance,
    required String type,
    required String tenantId,
  }) {
    return _remoteDataSource
        .createWallet(
          CreateWalletRequestModel(
            name: name,
            number: number,
            branchId: branchId,
            balance: balance,
            type: type,
            tenantId: tenantId,
          ),
        )
        .then(_unwrap);
  }

  @override
  Future<Wallet> updateWallet({
    required String walletId,
    required String name,
    required bool active,
  }) {
    return _remoteDataSource
        .updateWallet(
          walletId: walletId,
          request: UpdateWalletRequestModel(name: name, active: active),
        )
        .then(_unwrap);
  }

  @override
  Future<void> deleteWallet(String walletId) {
    return _remoteDataSource.deleteWallet(walletId).then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
