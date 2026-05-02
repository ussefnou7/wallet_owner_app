import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';
import '../models/wallet_model.dart';

class MockWalletsRepository implements WalletsRepository {
  final List<WalletModel> _wallets = [
    const WalletModel(
      id: 'wallet-1',
      name: 'Main Wallet',
      code: 'MW-001',
      balance: 154200,
      status: WalletStatus.active,
      transactionCount: 428,
      branchName: 'Head Office',
      walletProfit: 8400,
      cashProfit: 2150,
      collectedAt: DateTime(2026, 4, 28, 14, 30),
      collectedByName: 'Ussef',
      lastProfitCollectionAt: DateTime(2026, 4, 28, 14, 30),
    ),
    const WalletModel(
      id: 'wallet-2',
      name: 'Branch Wallet',
      code: 'BW-014',
      balance: 38420,
      status: WalletStatus.active,
      transactionCount: 163,
      branchName: 'Nasr City',
      walletProfit: 1700,
      cashProfit: 650,
      collectedAt: DateTime(2026, 5, 1, 10, 15),
      lastProfitCollectionAt: DateTime(2026, 5, 1, 10, 15),
    ),
    const WalletModel(
      id: 'wallet-3',
      name: 'Delivery Wallet',
      code: 'DW-007',
      balance: 12980,
      status: WalletStatus.inactive,
      active: false,
      transactionCount: 57,
      branchName: 'Alexandria',
      walletProfit: 0,
      cashProfit: 210,
    ),
    const WalletModel(
      id: 'wallet-4',
      name: 'VIP Customer Wallet',
      code: 'VW-021',
      balance: 89500,
      status: WalletStatus.active,
      transactionCount: 204,
      branchName: 'Maadi',
      walletProfit: 4900,
      cashProfit: 1200,
      collectedAt: DateTime(2026, 4, 18, 18, 45),
      collectedByName: 'Aya Hassan',
      lastProfitCollectionAt: DateTime(2026, 4, 18, 18, 45),
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
      collectedAt: wallet.collectedAt,
      collectedByName: wallet.collectedByName,
      lastProfitCollectionAt: wallet.lastProfitCollectionAt,
      walletProfit: wallet.walletProfit,
      cashProfit: wallet.cashProfit,
      dailySpent: wallet.dailySpent,
      monthlySpent: wallet.monthlySpent,
      dailyPercent: wallet.dailyPercent,
      monthlyPercent: wallet.monthlyPercent,
    );
  }

  @override
  Future<Wallet?> collectProfit({
    required String walletId,
    required double walletProfitAmount,
    required double cashProfitAmount,
    String? note,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _wallets.indexWhere((wallet) => wallet.id == walletId);
    final wallet = _wallets[index];
    final updated = WalletModel(
      id: wallet.id,
      tenantId: wallet.tenantId,
      tenantName: wallet.tenantName,
      branchId: wallet.branchId,
      name: wallet.name,
      number: wallet.number,
      code: wallet.code,
      balance: wallet.balance,
      dailyLimit: wallet.dailyLimit,
      monthlyLimit: wallet.monthlyLimit,
      active: wallet.active,
      status: wallet.status,
      transactionCount: wallet.transactionCount,
      branchName: wallet.branchName,
      rawType: wallet.rawType,
      walletProfit: (wallet.walletProfit - walletProfitAmount).clamp(
        0,
        double.infinity,
      ),
      cashProfit: (wallet.cashProfit - cashProfitAmount).clamp(
        0,
        double.infinity,
      ),
      dailySpent: wallet.dailySpent,
      monthlySpent: wallet.monthlySpent,
      dailyPercent: wallet.dailyPercent,
      monthlyPercent: wallet.monthlyPercent,
      collectedAt: DateTime.now(),
      collectedByName: 'Current User',
      lastProfitCollectionAt: DateTime.now(),
    );
    _wallets[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteWallet(String walletId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
