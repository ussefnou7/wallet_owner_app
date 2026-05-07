import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/services/wallets_remote_data_source.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/wallets_repository.dart';

final walletsSearchQueryProvider = StateProvider<String>((ref) => '');
final walletSortOptionProvider = StateProvider<WalletSortOption>(
  (ref) => WalletSortOption.defaultOrder,
);

enum WalletSortOption {
  defaultOrder,
  nearLimitFirst,
  highestDailyUsage,
  highestMonthlyUsage,
  highestLimit,
}

final walletTypesProvider = FutureProvider.autoDispose<List<String>>((
  ref,
) async {
  final session = ref.watch(authenticatedSessionProvider);
  if (session == null) {
    return const <String>[];
  }

  final remoteDataSource = ref.watch(walletsRemoteDataSourceProvider);
  final result = await remoteDataSource.getWalletTypes();
  return result.when(
    success: (data) => data,
    failure: (failure) => throw failure,
  );
});

final walletsControllerProvider =
    StateNotifierProvider<WalletsController, WalletListState>((ref) {
      ref.watch(sessionScopeKeyProvider);
      final repository = ref.watch(walletsRepositoryProvider);
      return WalletsController(repository, ref);
    });

final filteredWalletsProvider = Provider<List<Wallet>>((ref) {
  final state = ref.watch(walletsControllerProvider);
  final query = ref.watch(walletsSearchQueryProvider).trim().toLowerCase();

  final wallets = state.data;
  if (query.isEmpty) {
    return wallets;
  }

  return wallets.where((wallet) {
    return wallet.name.toLowerCase().contains(query) ||
        wallet.code.toLowerCase().contains(query) ||
        (wallet.branchName?.toLowerCase().contains(query) ?? false);
  }).toList();
});

final sortedWalletsProvider = Provider<List<Wallet>>((ref) {
  final wallets = ref.watch(filteredWalletsProvider);
  final sortOption = ref.watch(walletSortOptionProvider);

  if (sortOption == WalletSortOption.defaultOrder) {
    return wallets;
  }

  final sortedWallets = List<Wallet>.from(wallets);
  sortedWallets.sort((a, b) {
    final comparison = switch (sortOption) {
      WalletSortOption.defaultOrder => 0,
      WalletSortOption.nearLimitFirst => _compareDescending(
        _highestUsagePercent(b),
        _highestUsagePercent(a),
      ),
      WalletSortOption.highestDailyUsage => _compareDescending(
        b.dailyPercent,
        a.dailyPercent,
      ),
      WalletSortOption.highestMonthlyUsage => _compareDescending(
        b.monthlyPercent,
        a.monthlyPercent,
      ),
      WalletSortOption.highestLimit => _compareDescending(
        _highestLimitValue(b),
        _highestLimitValue(a),
      ),
    };

    if (comparison != 0) {
      return comparison;
    }

    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return sortedWallets;
});

final walletDetailsProvider = FutureProvider.autoDispose.family<Wallet, String>(
  (ref, walletId) {
    ref.watch(sessionScopeKeyProvider);
    final repository = ref.watch(walletsRepositoryProvider);
    return repository.getWalletById(walletId);
  },
);

class WalletListState {
  const WalletListState({
    this.data = const [],
    this.isLoading = false,
    this.error,
    this.isCreating = false,
    this.isUpdating = false,
    this.isCollectingProfit = false,
    this.isDeleting = false,
  });

  final List<Wallet> data;
  final bool isLoading;
  final AppException? error;
  final bool isCreating;
  final bool isUpdating;
  final bool isCollectingProfit;
  final bool isDeleting;

  WalletListState copyWith({
    List<Wallet>? data,
    bool? isLoading,
    AppException? error,
    bool? isCreating,
    bool? isUpdating,
    bool? isCollectingProfit,
    bool? isDeleting,
    bool clearError = false,
  }) {
    return WalletListState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      isCreating: isCreating ?? this.isCreating,
      isUpdating: isUpdating ?? this.isUpdating,
      isCollectingProfit: isCollectingProfit ?? this.isCollectingProfit,
      isDeleting: isDeleting ?? this.isDeleting,
    );
  }
}

class WalletsController extends StateNotifier<WalletListState> {
  WalletsController(this._repository, this._ref)
    : super(const WalletListState()) {
    if (_hasAuthenticatedSession) {
      _loadWallets();
    }
  }

  final WalletsRepository _repository;
  final Ref _ref;

  Future<void> _loadWallets() async {
    if (!_hasAuthenticatedSession) {
      state = const WalletListState();
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final wallets = await _repository.getWallets();
      state = state.copyWith(data: wallets, isLoading: false);
    } on AppException catch (error) {
      state = state.copyWith(isLoading: false, error: error);
    }
  }

  Future<void> reload() async {
    await _loadWallets();
  }

  Future<void> createWallet({
    required String name,
    required String number,
    required String branchId,
    required double balance,
    required double dailyLimit,
    required double monthlyLimit,
    required String type,
    required String tenantId,
  }) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    state = state.copyWith(isCreating: true, clearError: true);
    try {
      await _repository.createWallet(
        name: name,
        number: number,
        branchId: branchId,
        balance: balance,
        dailyLimit: dailyLimit,
        monthlyLimit: monthlyLimit,
        type: type,
        tenantId: tenantId,
      );
      await _loadWallets();
      state = state.copyWith(isCreating: false, clearError: true);
    } on AppException catch (error) {
      state = state.copyWith(isCreating: false, error: error);
    }
  }

  Future<void> updateWallet({
    required String walletId,
    required String name,
    required bool active,
    required double dailyLimit,
    required double monthlyLimit,
  }) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    state = state.copyWith(isUpdating: true, clearError: true);
    try {
      await _repository.updateWallet(
        walletId: walletId,
        name: name,
        active: active,
        dailyLimit: dailyLimit,
        monthlyLimit: monthlyLimit,
      );
      await _loadWallets();
    } on AppException catch (error) {
      state = state.copyWith(isUpdating: false, error: error);
    }
  }

  Future<void> deleteWallet(String walletId) async {
    if (!_hasAuthenticatedSession) {
      return;
    }

    state = state.copyWith(isDeleting: true, clearError: true);
    try {
      await _repository.deleteWallet(walletId);
      await _loadWallets();
    } on AppException catch (error) {
      state = state.copyWith(isDeleting: false, error: error);
    }
  }

  Future<bool> collectProfit({
    required String walletId,
    required double walletProfitAmount,
    required double cashProfitAmount,
    String? note,
  }) async {
    if (!_hasAuthenticatedSession) {
      return false;
    }

    state = state.copyWith(isCollectingProfit: true, clearError: true);
    try {
      final updatedWallet = await _repository.collectProfit(
        walletId: walletId,
        walletProfitAmount: walletProfitAmount,
        cashProfitAmount: cashProfitAmount,
        note: note,
      );
      if (updatedWallet != null) {
        state = state.copyWith(
          data: [
            for (final wallet in state.data)
              wallet.id == walletId ? updatedWallet : wallet,
          ],
        );
      }
      _ref.invalidate(walletDetailsProvider(walletId));
      await _loadWallets();
      state = state.copyWith(isCollectingProfit: false);
      return true;
    } on AppException catch (error) {
      state = state.copyWith(isCollectingProfit: false, error: error);
      return false;
    }
  }

  void updateQuery(String value) {
    _ref.read(walletsSearchQueryProvider.notifier).state = value;
  }

  void updateSortOption(WalletSortOption value) {
    _ref.read(walletSortOptionProvider.notifier).state = value;
  }

  bool get _hasAuthenticatedSession {
    return _ref.read(authenticatedSessionProvider) != null;
  }
}

double _highestUsagePercent(Wallet wallet) {
  return wallet.dailyPercent > wallet.monthlyPercent
      ? wallet.dailyPercent
      : wallet.monthlyPercent;
}

double _highestLimitValue(Wallet wallet) {
  return wallet.dailyLimit > wallet.monthlyLimit
      ? wallet.dailyLimit
      : wallet.monthlyLimit;
}

int _compareDescending(double left, double right) {
  return left.compareTo(right);
}
