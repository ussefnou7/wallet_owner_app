import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';
import '../models/wallet_model.dart';

class MockWalletsRepository implements WalletsRepository {
  @override
  Future<List<Wallet>> getWallets() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));

    return const [
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
  }
}
