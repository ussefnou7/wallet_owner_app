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

  Future<Wallet> createWallet({
    required String name,
    required String number,
    required String branchId,
    required double balance,
    required double dailyLimit,
    required double monthlyLimit,
    required String type,
    required String tenantId,
  });

  Future<Wallet> updateWallet({
    required String walletId,
    required String name,
    required bool active,
    required double dailyLimit,
    required double monthlyLimit,
  });

  Future<Wallet?> collectProfit({
    required String walletId,
    required double walletProfitAmount,
    required double cashProfitAmount,
    String? note,
  });

  Future<void> deleteWallet(String walletId);
}
