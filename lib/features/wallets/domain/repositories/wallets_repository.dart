import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/wallet.dart';

final walletsRepositoryProvider = Provider<WalletsRepository>((ref) {
  throw UnimplementedError(
    'walletsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class WalletsRepository {
  Future<List<Wallet>> getWallets();

  Future<Wallet> getWalletById(String walletId);

  Future<Wallet> createWallet({required String name});

  Future<Wallet> updateWallet({
    required String walletId,
    required String name,
    required bool active,
  });

  Future<void> deleteWallet(String walletId);
}
