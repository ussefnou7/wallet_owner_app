import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/wallet.dart';

final walletsRepositoryProvider = Provider<WalletsRepository>((ref) {
  throw UnimplementedError(
    'walletsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class WalletsRepository {
  Future<List<Wallet>> getWallets();
}
