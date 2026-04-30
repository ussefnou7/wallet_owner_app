import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';
import '../models/wallet_model.dart';

class MockWalletsRepository implements WalletsRepository {
  static const _wallets = [
    WalletModel(
      id: 'wallet-1',
      name: 'Main Wallet',
      code: 'MW-001',
      balance: 154200,
      status: WalletStatus.active,
      transactionCount: 428,
      branchName: 'Head Office',
    ),
    WalletModel(
      id: 'wallet-2',
      name: 'Branch Wallet',
      code: 'BW-014',
      balance: 38420,
      status: WalletStatus.active,
      transactionCount: 163,
      branchName: 'Nasr City',
    ),
    WalletModel(
      id: 'wallet-3',
      name: 'Delivery Wallet',
      code: 'DW-007',
      balance: 12980,
      status: WalletStatus.inactive,
      active: false,
      transactionCount: 57,
      branchName: 'Alexandria',
    ),
    WalletModel(
      id: 'wallet-4',
      name: 'VIP Customer Wallet',
      code: 'VW-021',
      balance: 89500,
      status: WalletStatus.active,
      transactionCount: 204,
      branchName: 'Maadi',
    ),
  ];

  @override
  Future<List<Wallet>> getWallets() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _wallets;
  }

  @override
  Future<Wallet> getWalletById(String walletId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _wallets.firstWhere((wallet) => wallet.id == walletId);
  }

  @override
  Future<Wallet> createWallet({
    required String name,
    required String number,
    required String branchId,
    required double balance,
    required double dailyLimit,
    required double monthlyLimit,
    required String type,
    required String tenantId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return WalletModel(
      id: 'wallet-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      number: number,
      code: 'NEW',
      balance: balance,
      dailyLimit: dailyLimit,
      monthlyLimit: monthlyLimit,
      status: WalletStatus.active,
      transactionCount: 0,
      branchId: branchId,
      rawType: type,
    );
  }

  @override
  Future<Wallet> updateWallet({
    required String walletId,
    required String name,
    required bool active,
    required double dailyLimit,
    required double monthlyLimit,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final wallet = _wallets.firstWhere((wallet) => wallet.id == walletId);
    return WalletModel(
      id: wallet.id,
      name: name,
      code: wallet.code,
      balance: wallet.balance,
      dailyLimit: dailyLimit,
      monthlyLimit: monthlyLimit,
      active: active,
      status: active ? WalletStatus.active : WalletStatus.inactive,
      transactionCount: wallet.transactionCount,
      branchName: wallet.branchName,
      walletProfit: wallet.walletProfit,
      cashProfit: wallet.cashProfit,
      dailySpent: wallet.dailySpent,
      monthlySpent: wallet.monthlySpent,
      dailyPercent: wallet.dailyPercent,
      monthlyPercent: wallet.monthlyPercent,
    );
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
