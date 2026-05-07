import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../wallets/domain/entities/wallet_option.dart';
import '../../../wallets/domain/repositories/wallets_repository.dart';

final reportWalletOptionsProvider = FutureProvider.autoDispose
    .family<List<WalletOption>, String?>((ref, branchId) {
      final session = ref.watch(authenticatedSessionProvider);
      if (session == null) {
        return const <WalletOption>[];
      }

      final repository = ref.watch(walletsRepositoryProvider);
      return repository.getWalletOptions(branchId: _normalizeId(branchId));
    });

String? _normalizeId(String? value) {
  final trimmed = value?.trim();
  if (trimmed == null || trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}
