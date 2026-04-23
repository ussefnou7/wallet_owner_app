import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';

final walletsSearchQueryProvider = StateProvider<String>((ref) => '');

final walletsControllerProvider =
    AsyncNotifierProvider<WalletsController, List<Wallet>>(
      WalletsController.new,
    );

final filteredWalletsProvider = Provider<List<Wallet>>((ref) {
  final walletsAsync = ref.watch(walletsControllerProvider);
  final query = ref.watch(walletsSearchQueryProvider).trim().toLowerCase();

  return walletsAsync.maybeWhen(
    data: (wallets) {
      if (query.isEmpty) {
        return wallets;
      }

      return wallets.where((wallet) {
        return wallet.name.toLowerCase().contains(query) ||
            wallet.code.toLowerCase().contains(query) ||
            (wallet.branchName?.toLowerCase().contains(query) ?? false);
      }).toList();
    },
    orElse: () => const [],
  );
});

final walletDetailsProvider = FutureProvider.family<Wallet, String>((
  ref,
  walletId,
) {
  final repository = ref.watch(walletsRepositoryProvider);
  return repository.getWalletById(walletId);
});

class WalletsController extends AsyncNotifier<List<Wallet>> {
  @override
  Future<List<Wallet>> build() async {
    final repository = ref.watch(walletsRepositoryProvider);
    return repository.getWallets();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(walletsRepositoryProvider);
      return repository.getWallets();
    });
  }

  Future<void> createWallet({required String name}) async {
    final repository = ref.read(walletsRepositoryProvider);
    await repository.createWallet(name: name);
    await reload();
  }

  Future<void> updateWallet({
    required String walletId,
    required String name,
    required bool active,
  }) async {
    final repository = ref.read(walletsRepositoryProvider);
    await repository.updateWallet(
      walletId: walletId,
      name: name,
      active: active,
    );
    await reload();
    ref.invalidate(walletDetailsProvider(walletId));
  }

  Future<void> deleteWallet(String walletId) async {
    final repository = ref.read(walletsRepositoryProvider);
    await repository.deleteWallet(walletId);
    await reload();
    ref.invalidate(walletDetailsProvider(walletId));
  }

  void updateQuery(String value) {
    ref.read(walletsSearchQueryProvider.notifier).state = value;
  }
}
