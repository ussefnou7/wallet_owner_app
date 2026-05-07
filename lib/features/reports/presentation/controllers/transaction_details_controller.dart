import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/models/paged_response.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../../transactions/domain/entities/transaction_record.dart';
import '../../../transactions/domain/repositories/transactions_repository.dart';
import '../../domain/entities/transaction_details_filters.dart';

final transactionDetailsControllerProvider =
    StateNotifierProvider.autoDispose<
      TransactionDetailsController,
      TransactionDetailsState
    >((ref) {
      final repository = ref.watch(transactionsRepositoryProvider);
      ref.watch(sessionScopeKeyProvider);
      return TransactionDetailsController(repository, ref);
    });

class TransactionDetailsState {
  TransactionDetailsState({
    required this.filters,
    this.transactions = const [],
    this.page = 0,
    this.hasMore = false,
    this.isInitialLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.error,
    this.loadMoreError,
  });

  factory TransactionDetailsState.initial() {
    return TransactionDetailsState(
      filters: TransactionDetailsFilters.currentMonth(),
      isInitialLoading: true,
    );
  }

  factory TransactionDetailsState.unauthenticated() {
    return TransactionDetailsState(
      filters: TransactionDetailsFilters.currentMonth(),
    );
  }

  final TransactionDetailsFilters filters;
  final List<TransactionRecord> transactions;
  final int page;
  final bool hasMore;
  final bool isInitialLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final AppException? error;
  final AppException? loadMoreError;

  TransactionDetailsState copyWith({
    TransactionDetailsFilters? filters,
    List<TransactionRecord>? transactions,
    int? page,
    bool? hasMore,
    bool? isInitialLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    AppException? error,
    AppException? loadMoreError,
    bool clearError = false,
    bool clearLoadMoreError = false,
  }) {
    return TransactionDetailsState(
      filters: filters ?? this.filters,
      transactions: transactions ?? this.transactions,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: clearError ? null : error ?? this.error,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }
}

class TransactionDetailsController
    extends StateNotifier<TransactionDetailsState> {
  TransactionDetailsController(this._repository, this._ref)
    : super(
        _ref.read(authenticatedSessionProvider) == null
            ? TransactionDetailsState.unauthenticated()
            : TransactionDetailsState.initial(),
      ) {
    if (_hasAuthenticatedSession) {
      unawaited(_loadPage(filters: state.filters, reset: true));
    }
  }

  final TransactionsRepository _repository;
  final Ref _ref;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> applyFilters(TransactionDetailsFilters filters) async {
    final normalized = filters.normalized().copyWith(page: 0);

    state = state.copyWith(
      filters: normalized,
      transactions: const [],
      page: 0,
      hasMore: false,
      isInitialLoading: true,
      isRefreshing: false,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );

    await _loadPage(filters: normalized, reset: true);
  }

  Future<void> refresh() async {
    final refreshedFilters = state.filters.copyWith(page: 0).normalized();
    state = state.copyWith(
      filters: refreshedFilters,
      isInitialLoading: state.transactions.isEmpty,
      isRefreshing: state.transactions.isNotEmpty,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );

    await _loadPage(filters: refreshedFilters, reset: true);
  }

  Future<void> retry() async {
    await refresh();
  }

  Future<void> loadMore() async {
    if (state.isInitialLoading ||
        state.isRefreshing ||
        state.isLoadingMore ||
        !state.hasMore) {
      return;
    }

    final nextFilters = state.filters
        .copyWith(page: state.page + 1)
        .normalized();
    state = state.copyWith(
      filters: nextFilters,
      isLoadingMore: true,
      clearLoadMoreError: true,
    );

    await _loadPage(filters: nextFilters, reset: false);
  }

  Future<void> _loadPage({
    required TransactionDetailsFilters filters,
    required bool reset,
  }) async {
    if (!_hasAuthenticatedSession) {
      state = TransactionDetailsState(
        filters: filters.copyWith(page: 0),
        transactions: const [],
        page: 0,
        hasMore: false,
        isInitialLoading: false,
        isRefreshing: false,
        isLoadingMore: false,
      );
      return;
    }

    final requestId = ++_requestSequence;
    _latestRequestId = requestId;

    try {
      final response = await _repository.getTransactions(
        filter: filters.toTransactionsFilterState(),
      );
      if (requestId != _latestRequestId) {
        return;
      }

      _applyResponse(filters, response, reset: reset);
    } on AppException catch (error) {
      if (requestId != _latestRequestId) {
        return;
      }

      if (reset) {
        state = state.copyWith(
          filters: filters,
          transactions: state.isRefreshing ? state.transactions : const [],
          page: reset ? 0 : state.page,
          hasMore: reset && !state.isRefreshing ? false : state.hasMore,
          isInitialLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          error: error,
          clearLoadMoreError: true,
        );
      } else {
        state = state.copyWith(
          filters: filters.copyWith(page: state.page),
          isLoadingMore: false,
          loadMoreError: error,
        );
      }
    } catch (_) {
      if (requestId != _latestRequestId) {
        return;
      }

      const fallback = AppException(code: 'UNKNOWN_ERROR', message: '');
      if (reset) {
        state = state.copyWith(
          filters: filters,
          transactions: state.isRefreshing ? state.transactions : const [],
          page: reset ? 0 : state.page,
          hasMore: reset && !state.isRefreshing ? false : state.hasMore,
          isInitialLoading: false,
          isRefreshing: false,
          isLoadingMore: false,
          error: fallback,
          clearLoadMoreError: true,
        );
      } else {
        state = state.copyWith(
          filters: filters.copyWith(page: state.page),
          isLoadingMore: false,
          loadMoreError: fallback,
        );
      }
    }
  }

  void _applyResponse(
    TransactionDetailsFilters requestedFilters,
    PagedResponse<TransactionRecord> response, {
    required bool reset,
  }) {
    final resolvedFilters = requestedFilters.copyWith(
      page: response.page,
      size: response.size == 0 ? requestedFilters.size : response.size,
    );
    final nextTransactions = reset
        ? response.content
        : [...state.transactions, ...response.content];

    state = state.copyWith(
      filters: resolvedFilters,
      transactions: nextTransactions,
      page: response.page,
      hasMore: response.hasNext && !response.last,
      isInitialLoading: false,
      isRefreshing: false,
      isLoadingMore: false,
      clearError: true,
      clearLoadMoreError: true,
    );
  }

  bool get _hasAuthenticatedSession {
    return _ref.read(authenticatedSessionProvider) != null;
  }
}
