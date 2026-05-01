import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';
import '../../domain/repositories/transactions_repository.dart';

enum TransactionFilterType { all, credit, debit }

final transactionsSearchQueryProvider = StateProvider<String>((ref) => '');
final transactionsFilterProvider = StateProvider<TransactionFilterType>(
  (ref) => TransactionFilterType.all,
);

final transactionsControllerProvider =
    StateNotifierProvider<TransactionsController, TransactionsListState>((ref) {
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

final transactionDetailsProvider =
    FutureProvider.family<TransactionRecord, String>((ref, transactionId) {
      final repository = ref.watch(transactionsRepositoryProvider);
      return repository.getTransactionById(transactionId);
    });

class TransactionsListState {
  const TransactionsListState({
    this.transactions = const [],
    this.currentPage = 0,
    this.pageSize = 20,
    this.hasNext = false,
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.loadMoreError,
    this.activeFilter = TransactionFilterType.all,
    this.walletId,
    this.dateFrom,
    this.dateTo,
  });

  final List<TransactionRecord> transactions;
  final int currentPage;
  final int pageSize;
  final bool hasNext;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final AppException? errorMessage;
  final AppException? loadMoreError;
  final TransactionFilterType activeFilter;
  final String? walletId;
  final DateTime? dateFrom;
  final DateTime? dateTo;

  TransactionsListState copyWith({
    List<TransactionRecord>? transactions,
    int? currentPage,
    int? pageSize,
    bool? hasNext,
    bool? isInitialLoading,
    bool? isLoadingMore,
    AppException? errorMessage,
    AppException? loadMoreError,
    TransactionFilterType? activeFilter,
    String? walletId,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearErrorMessage = false,
    bool clearLoadMoreError = false,
    bool preserveWalletId = true,
    bool preserveDateFrom = true,
    bool preserveDateTo = true,
  }) {
    return TransactionsListState(
      transactions: transactions ?? this.transactions,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
      hasNext: hasNext ?? this.hasNext,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
      activeFilter: activeFilter ?? this.activeFilter,
      walletId: preserveWalletId ? (walletId ?? this.walletId) : walletId,
      dateFrom: preserveDateFrom ? (dateFrom ?? this.dateFrom) : dateFrom,
      dateTo: preserveDateTo ? (dateTo ?? this.dateTo) : dateTo,
    );
  }
}

class TransactionsController extends StateNotifier<TransactionsListState> {
  TransactionsController(this._repository, this._ref)
    : super(
        TransactionsListState(
          activeFilter: _ref.read(transactionsFilterProvider),
        ),
      ) {
    _loadPage(reset: true);
  }

  final TransactionsRepository _repository;
  final Ref _ref;

  Future<void> reload() async {
    await _loadPage(reset: true);
  }

  Future<void> refresh() async {
    await _loadPage(reset: true);
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || state.isInitialLoading || !state.hasNext) {
      return;
    }

    await _loadPage(page: state.currentPage + 1, reset: false);
  }

  Future<void> applyFilters({
    String? walletId,
    DateTime? dateFrom,
    DateTime? dateTo,
    bool clearWalletId = false,
    bool clearDateFrom = false,
    bool clearDateTo = false,
  }) async {
    state = state.copyWith(
      walletId: clearWalletId ? null : walletId,
      dateFrom: clearDateFrom ? null : dateFrom,
      dateTo: clearDateTo ? null : dateTo,
      preserveWalletId: false,
      preserveDateFrom: false,
      preserveDateTo: false,
    );
    await _loadPage(reset: true);
  }

  void updateQuery(String value) {
    _ref.read(transactionsSearchQueryProvider.notifier).state = value;
  }

  Future<void> updateFilter(TransactionFilterType value) async {
    if (value == state.activeFilter) {
      return;
    }

    _ref.read(transactionsFilterProvider.notifier).state = value;
    state = state.copyWith(activeFilter: value);
    await _loadPage(reset: true);
  }

  Future<void> _loadPage({int? page, required bool reset}) async {
    final requestedPage = reset ? 0 : (page ?? state.currentPage + 1);
    final nextFilter = _resolveFilterType(
      _ref.read(transactionsFilterProvider),
    );

    if (reset) {
      state = state.copyWith(
        transactions: const [],
        currentPage: 0,
        hasNext: false,
        isInitialLoading: true,
        isLoadingMore: false,
        activeFilter: _ref.read(transactionsFilterProvider),
        clearErrorMessage: true,
        clearLoadMoreError: true,
      );
    } else {
      state = state.copyWith(
        isLoadingMore: true,
        clearLoadMoreError: true,
        activeFilter: _ref.read(transactionsFilterProvider),
      );
    }

    try {
      final pageResponse = await _repository.getTransactions(
        walletId: state.walletId,
        type: nextFilter,
        dateFrom: state.dateFrom,
        dateTo: state.dateTo,
        page: requestedPage,
        size: state.pageSize,
      );

      state = state.copyWith(
        transactions: reset
            ? pageResponse.content
            : [...state.transactions, ...pageResponse.content],
        currentPage: pageResponse.page,
        pageSize: pageResponse.size == 0 ? state.pageSize : pageResponse.size,
        hasNext: pageResponse.hasNext,
        isInitialLoading: false,
        isLoadingMore: false,
        activeFilter: _ref.read(transactionsFilterProvider),
        clearErrorMessage: true,
        clearLoadMoreError: true,
      );
    } on AppException catch (error) {
      state = state.copyWith(
        isInitialLoading: false,
        isLoadingMore: false,
        errorMessage: reset ? error : state.errorMessage,
        loadMoreError: reset ? null : error,
        clearErrorMessage: !reset,
      );
    }
  }

  static TransactionEntryType? _resolveFilterType(
    TransactionFilterType filter,
  ) {
    return switch (filter) {
      TransactionFilterType.all => null,
      TransactionFilterType.credit => TransactionEntryType.credit,
      TransactionFilterType.debit => TransactionEntryType.debit,
    };
  }
}
