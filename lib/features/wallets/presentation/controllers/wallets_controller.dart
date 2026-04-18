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

  void updateQuery(String value) {
    ref.read(walletsSearchQueryProvider.notifier).state = value;
  }
}
