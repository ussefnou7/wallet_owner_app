import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/domain/entities/session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../../domain/repositories/transactions_repository.dart';

enum TransactionFilterType { all, credit, debit }

final transactionsSearchQueryProvider = StateProvider<String>((ref) => '');

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsListState>((ref) {
      ref.watch(sessionScopeKeyProvider);
      final repository = ref.watch(transactionsRepositoryProvider);
      return TransactionsController(repository, ref);
    });

final filteredTransactionsProvider = Provider<List<TransactionRecord>>((ref) {
  final state = ref.watch(transactionsControllerProvider);
  final query = ref.watch(transactionsSearchQueryProvider).trim().toLowerCase();

  if (query.isEmpty) {
    return state.transactions;
  }

  return state.transactions
      .where((transaction) {
        return transaction.walletName.toLowerCase().contains(query) ||
            (transaction.note?.toLowerCase().contains(query) ?? false) ||
            (transaction.createdByUsername?.toLowerCase().contains(query) ??
                false);
      })
      .toList(growable: false);
});

final transactionDetailsProvider = FutureProvider.autoDispose
    .family<TransactionRecord, String>((ref, transactionId) {
      final session = ref.watch(authenticatedSessionProvider);
      if (session == null) {
        throw const AppException(code: 'UNAUTHENTICATED', message: '');
      }

      final repository = ref.watch(transactionsRepositoryProvider);
      return repository.getTransactionById(transactionId);
    });

class TransactionsListState {
  const TransactionsListState({
    this.transactions = const [],
    this.filter = const TransactionsFilterState(),
    this.hasNext = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreError,
  });

  final List<TransactionRecord> transactions;
  final TransactionsFilterState filter;
  final bool hasNext;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final AppException? errorMessage;
  final AppException? loadMoreError;

  int get currentPage => filter.page;

  int get pageSize => filter.size;

  TransactionFilterType get activeFilterType {
    return switch (filter.type) {
      TransactionEntryType.credit => TransactionFilterType.credit,
      TransactionEntryType.debit => TransactionFilterType.debit,
      _ => TransactionFilterType.all,
    };
  }

  TransactionsListState copyWith({
    List<TransactionRecord>? transactions,
    TransactionsFilterState? filter,
    bool? hasNext,
    bool? isInitialLoading,
    bool? isLoadingMore,
    AppException? errorMessage,
    AppException? loadMoreError,
    bool clearErrorMessage = false,
    bool clearLoadMoreError = false,
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      filter: filter ?? this.filter,
      hasNext: hasNext ?? this.hasNext,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }
}

class TransactionsController extends StateNotifier<TransactionsListState> {
  TransactionsController(this._repository, this._ref)
    : super(const TransactionsListState()) {
    if (_hasAuthenticatedSession) {
      unawaited(
        _fetchTransactions(
          filter: _sanitizeFilter(const TransactionsFilterState()),
          reset: true,
        ),
      );
    }
  }

  final TransactionsRepository _repository;
  final Ref _ref;
  TransactionsFilterState? _activeRequestFilter;
  bool? _activeRequestReset;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> reload() async {
    await refresh();
  }

  Future<void> refresh() async {
    await _fetchTransactions(
      filter: _sanitizeFilter(state.filter.copyWith(page: 0)),
      reset: true,
    );
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore ||
        state.isInitialLoading ||
        !state.hasNext ||
        state.transactions.isEmpty) {
      developer.log(
        'loadMoreTransactions skipped page=${state.currentPage} '
        'hasNext=${state.hasNext} '
        'isInitialLoading=${state.isInitialLoading} '
        'isLoadingMore=${state.isLoadingMore} '
        'items=${state.transactions.length}',
        name: 'transactions_controller',
      );
      return;
    }

    await _fetchTransactions(
      filter: _sanitizeFilter(
        state.filter.copyWith(page: state.currentPage + 1),
      ),
      reset: false,
    );
  }

  Future<void> applyFilters(TransactionsFilterState filter) async {
    await _fetchTransactions(
      filter: _sanitizeFilter(filter.copyWith(page: 0, size: state.pageSize)),
      reset: true,
    );
  }

  Future<void> clearWalletFilter() async {
    await applyFilters(state.filter.copyWith(clearWalletId: true));
  }

  Future<void> clearDateRangeFilter() async {
    await applyFilters(
      state.filter.copyWith(clearDateFrom: true, clearDateTo: true),
    );
  }

  Future<void> clearCreatedByFilter() async {
    await applyFilters(state.filter.copyWith(clearCreatedBy: true));
  }

  Future<void> clearAllFilters() async {
    await applyFilters(
      state.filter.clearAll(
        type: _transactionTypeFromFilter(state.activeFilterType),
      ),
    );
  }

  Future<void> updateFilterType(TransactionFilterType value) async {
    final resolvedType = _transactionTypeFromFilter(value);
    final requestedFilter = _sanitizeFilter(
      state.filter.copyWith(
        type: resolvedType,
        page: 0,
        clearType: resolvedType == null,
      ),
    );

    if (value == state.activeFilterType &&
        !_shouldReloadSelectedFilter(requestedFilter)) {
      return;
    }

    await _fetchTransactions(filter: requestedFilter, reset: true);
  }

  void updateQuery(String value) {
    _ref.read(transactionsSearchQueryProvider.notifier).state = value;
  }

  Future<void> _fetchTransactions({
    required TransactionsFilterState filter,
    required bool reset,
  }) async {
    if (!_hasAuthenticatedSession) {
      _activeRequestFilter = null;
      _activeRequestReset = null;
      state = const TransactionsListState();
      return;
    }

    final requestedFilter = reset ? filter.copyWith(page: 0) : filter;

    if (_activeRequestFilter == requestedFilter &&
        _activeRequestReset == reset) {
      developer.log(
        'transactions fetch skipped duplicate reset=$reset '
        'page=${requestedFilter.page} hasNext=${state.hasNext} '
        'isInitialLoading=${state.isInitialLoading} '
        'isLoadingMore=${state.isLoadingMore} '
        'type=${requestedFilter.type?.name ?? 'ALL'} '
        'walletId=${requestedFilter.walletId ?? '-'} '
        'createdBy=${requestedFilter.createdBy ?? '-'} '
        'dateFrom=${requestedFilter.dateFrom?.toIso8601String() ?? '-'} '
        'dateTo=${requestedFilter.dateTo?.toIso8601String() ?? '-'} '
        'size=${requestedFilter.size}',
        name: 'transactions_controller',
      );
      return;
    }

    developer.log(
      '${reset ? 'loadInitialTransactions' : 'loadMoreTransactions'} start '
      'page=${requestedFilter.page} hasNext=${state.hasNext} '
      'isInitialLoading=${state.isInitialLoading} '
      'isLoadingMore=${state.isLoadingMore} '
      'type=${requestedFilter.type?.name ?? 'ALL'} '
      'walletId=${requestedFilter.walletId ?? '-'} '
      'createdBy=${requestedFilter.createdBy ?? '-'} '
      'dateFrom=${requestedFilter.dateFrom?.toIso8601String() ?? '-'} '
      'dateTo=${requestedFilter.dateTo?.toIso8601String() ?? '-'} '
      'size=${requestedFilter.size}',
      name: 'transactions_controller',
    );

    _activeRequestFilter = requestedFilter;
    _activeRequestReset = reset;
    final requestId = ++_requestSequence;
    _latestRequestId = requestId;

    if (reset) {
      state = state.copyWith(
        transactions: const [],
        filter: requestedFilter,
        hasNext: false,
        isInitialLoading: true,
        isLoadingMore: false,
        clearErrorMessage: true,
        clearLoadMoreError: true,
      );
    } else {
      state = state.copyWith(
        filter: requestedFilter,
        isLoadingMore: true,
        clearLoadMoreError: true,
      );
    }

    try {
      final pageResponse = await _repository.getTransactions(
        filter: requestedFilter,
      );
      if (requestId != _latestRequestId) {
        developer.log(
          '${reset ? 'loadInitialTransactions' : 'loadMoreTransactions'} '
          'ignored stale response requestId=$requestId latest=$_latestRequestId '
          'page=${requestedFilter.page} '
          'type=${requestedFilter.type?.name ?? 'ALL'}',
          name: 'transactions_controller',
        );
        return;
      }

      final resolvedFilter = requestedFilter.copyWith(
        page: pageResponse.page,
        size: pageResponse.size == 0 ? requestedFilter.size : pageResponse.size,
      );
      final resolvedHasNext = pageResponse.hasNext && !pageResponse.last;

      state = state.copyWith(
        transactions: reset
            ? pageResponse.content
            : [...state.transactions, ...pageResponse.content],
        filter: resolvedFilter,
        hasNext: resolvedHasNext,
        isInitialLoading: false,
        isLoadingMore: false,
        clearErrorMessage: true,
        clearLoadMoreError: true,
      );
      developer.log(
        '${reset ? 'loadInitialTransactions' : 'loadMoreTransactions'} end '
        'page=${pageResponse.page} items=${pageResponse.content.length} '
        'totalLoaded=${state.transactions.length} '
        'hasNext=$resolvedHasNext last=${pageResponse.last} '
        'isInitialLoading=${state.isInitialLoading} '
        'isLoadingMore=${state.isLoadingMore}',
        name: 'transactions_controller',
      );
    } on AppException catch (error) {
      if (requestId != _latestRequestId) {
        developer.log(
          '${reset ? 'loadInitialTransactions' : 'loadMoreTransactions'} '
          'ignored stale error requestId=$requestId latest=$_latestRequestId '
          'page=${requestedFilter.page} code=${error.code} '
          'type=${requestedFilter.type?.name ?? 'ALL'}',
          name: 'transactions_controller',
        );
        return;
      }

      state = state.copyWith(
        filter: requestedFilter,
        isInitialLoading: false,
        isLoadingMore: false,
        errorMessage: reset ? error : state.errorMessage,
        loadMoreError: reset ? null : error,
        clearErrorMessage: !reset,
      );
      developer.log(
        '${reset ? 'loadInitialTransactions' : 'loadMoreTransactions'} error '
        'page=${requestedFilter.page} code=${error.code} '
        'hasNext=${state.hasNext} '
        'isInitialLoading=${state.isInitialLoading} '
        'isLoadingMore=${state.isLoadingMore}',
        name: 'transactions_controller',
        level: 900,
      );
    } finally {
      if (_activeRequestFilter == requestedFilter &&
          _activeRequestReset == reset &&
          requestId == _latestRequestId) {
        _activeRequestFilter = null;
        _activeRequestReset = null;
      }
    }
  }

  TransactionsFilterState _sanitizeFilter(TransactionsFilterState filter) {
    if (_canUseCreatedByFilter) {
      return filter;
    }

    return filter.copyWith(clearCreatedBy: true);
  }

  bool get _canUseCreatedByFilter {
    Session? session;
    try {
      session = _ref.read(authenticatedSessionProvider);
    } catch (_) {
      session = null;
    }
    return session?.isOwner == true;
  }

  bool get _hasAuthenticatedSession {
    return _ref.read(authenticatedSessionProvider) != null;
  }

  static TransactionEntryType? _transactionTypeFromFilter(
    TransactionFilterType filter,
  ) {
    return switch (filter) {
      TransactionFilterType.all => null,
      TransactionFilterType.credit => TransactionEntryType.credit,
      TransactionFilterType.debit => TransactionEntryType.debit,
    };
  }

  bool _shouldReloadSelectedFilter(TransactionsFilterState requestedFilter) {
    final hasInFlightDifferentRequest =
        _activeRequestFilter != null &&
        (_activeRequestFilter != requestedFilter ||
            _activeRequestReset != true);

    return state.transactions.isEmpty ||
        state.errorMessage != null ||
        state.loadMoreError != null ||
        state.filter.page != 0 ||
        state.filter != requestedFilter ||
        hasInFlightDifferentRequest;
  }
}
