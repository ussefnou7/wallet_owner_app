import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../transactions/domain/entities/transactions_filter_state.dart';
import '../../../transactions/domain/repositories/transactions_repository.dart';

final userDashboardRecentTransactionsControllerProvider =
    StateNotifierProvider.autoDispose<
      UserDashboardRecentTransactionsController,
      UserDashboardRecentTransactionsState
    >((ref) {
      ref.watch(sessionScopeKeyProvider);
      final repository = ref.watch(transactionsRepositoryProvider);
      return UserDashboardRecentTransactionsController(
        repository: repository,
        ref: ref,
      );
    });

class UserDashboardRecentTransactionsState {
  const UserDashboardRecentTransactionsState({
    this.items = const <TransactionRecord>[],
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasLoadedOnce = false,
    this.error,
  });

  final List<TransactionRecord> items;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasLoadedOnce;
  final AppException? error;

  UserDashboardRecentTransactionsState copyWith({
    List<TransactionRecord>? items,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasLoadedOnce,
    AppException? error,
    bool clearError = false,
  }) {
    return UserDashboardRecentTransactionsState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class UserDashboardRecentTransactionsController
    extends StateNotifier<UserDashboardRecentTransactionsState> {
  UserDashboardRecentTransactionsController({
    required TransactionsRepository repository,
    required Ref ref,
  }) : _repository = repository,
       _ref = ref,
       super(
         ref.read(authenticatedSessionProvider) == null
             ? const UserDashboardRecentTransactionsState()
             : const UserDashboardRecentTransactionsState(isLoading: true),
       ) {
    if (_hasAuthenticatedSession) {
      unawaited(loadInitial());
    }
  }

  final TransactionsRepository _repository;
  final Ref _ref;
  Future<void>? _activeRequest;

  Future<void> loadInitial() async {
    if (state.hasLoadedOnce) {
      return;
    }

    await _load(force: false);
  }

  Future<void> refresh() async {
    await _load(force: true);
  }

  Future<void> retry() async {
    await _load(force: true);
  }

  Future<void> _load({required bool force}) {
    if (!_hasAuthenticatedSession) {
      state = const UserDashboardRecentTransactionsState();
      return Future.value();
    }

    if (!force && state.hasLoadedOnce) {
      return Future.value();
    }

    final activeRequest = _activeRequest;
    if (activeRequest != null) {
      return activeRequest;
    }

    state = state.copyWith(
      isLoading: !state.hasLoadedOnce,
      isRefreshing: state.hasLoadedOnce,
      clearError: true,
    );

    final future = _performLoad();
    _activeRequest = future;
    return future.whenComplete(() {
      if (identical(_activeRequest, future)) {
        _activeRequest = null;
      }
    });
  }

  Future<void> _performLoad() async {
    final session = _ref.read(authenticatedSessionProvider);
    if (session == null) {
      state = const UserDashboardRecentTransactionsState();
      return;
    }

    try {
      final page = await _repository.getTransactions(
        filter: TransactionsFilterState(
          createdBy: session.userId,
          page: 0,
          size: 5,
        ),
      );

      state = state.copyWith(
        items: page.content,
        isLoading: false,
        isRefreshing: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: const AppException(code: 'UNKNOWN_ERROR', message: ''),
      );
    }
  }

  bool get _hasAuthenticatedSession {
    return _ref.read(authenticatedSessionProvider) != null;
  }
}
