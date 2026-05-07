import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/transaction_summary_filters.dart';
import '../../domain/entities/transaction_summary_response.dart';
import '../../domain/repositories/transaction_summary_repository.dart';

final transactionSummaryControllerProvider =
    StateNotifierProvider.autoDispose<
      TransactionsSummaryController,
      TransactionsSummaryState
    >((ref) {
      final repository = ref.watch(transactionSummaryRepositoryProvider);
      ref.watch(sessionScopeKeyProvider);
      return TransactionsSummaryController(repository, ref);
    });

class TransactionsSummaryState {
  TransactionsSummaryState({
    required this.filters,
    this.response,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  factory TransactionsSummaryState.initial() {
    return TransactionsSummaryState(
      filters: TransactionSummaryFilters.currentMonth(),
      isLoading: true,
    );
  }

  factory TransactionsSummaryState.unauthenticated() {
    return TransactionsSummaryState(
      filters: TransactionSummaryFilters.currentMonth(),
    );
  }

  final TransactionSummaryFilters filters;
  final TransactionSummaryResponse? response;
  final bool isLoading;
  final bool isRefreshing;
  final AppException? error;

  TransactionsSummaryState copyWith({
    TransactionSummaryFilters? filters,
    TransactionSummaryResponse? response,
    bool? isLoading,
    bool? isRefreshing,
    AppException? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return TransactionsSummaryState(
      filters: filters ?? this.filters,
      response: clearResponse ? null : response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class TransactionsSummaryController
    extends StateNotifier<TransactionsSummaryState> {
  TransactionsSummaryController(this._repository, this._ref)
    : super(
        _ref.read(authenticatedSessionProvider) == null
            ? TransactionsSummaryState.unauthenticated()
            : TransactionsSummaryState.initial(),
      ) {
    if (_hasAuthenticatedSession) {
      unawaited(_load(filters: state.filters, keepExistingData: false));
    }
  }

  final TransactionSummaryRepository _repository;
  final Ref _ref;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> applyFilters(TransactionSummaryFilters filters) async {
    final normalized = filters.normalized();

    if (normalized == state.filters) {
      await refresh();
      return;
    }

    state = state.copyWith(
      filters: normalized,
      isLoading: true,
      isRefreshing: false,
      clearError: true,
      clearResponse: true,
    );

    await _load(filters: normalized, keepExistingData: false);
  }

  Future<void> clearFilters() async {
    await applyFilters(TransactionSummaryFilters.currentMonth());
  }

  Future<void> refresh() async {
    await _load(
      filters: state.filters,
      keepExistingData: state.response != null,
    );
  }

  Future<void> retry() async {
    await _load(
      filters: state.filters,
      keepExistingData: state.response != null,
    );
  }

  Future<void> _load({
    required TransactionSummaryFilters filters,
    required bool keepExistingData,
  }) async {
    if (!_hasAuthenticatedSession) {
      state = TransactionsSummaryState(
        filters: filters,
        response: null,
        isLoading: false,
        isRefreshing: false,
      );
      return;
    }

    final requestId = ++_requestSequence;
    _latestRequestId = requestId;

    state = state.copyWith(
      filters: filters,
      isLoading: !keepExistingData,
      isRefreshing: keepExistingData,
      clearError: true,
    );

    try {
      final response = await _repository.getTransactionSummary(
        filters: filters,
      );
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        response: response,
        isLoading: false,
        isRefreshing: false,
        clearError: true,
      );
    } on AppException catch (error) {
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
        clearResponse: !keepExistingData,
      );
    } catch (_) {
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: const AppException(code: 'UNKNOWN_ERROR', message: ''),
        clearResponse: !keepExistingData,
      );
    }
  }

  bool get _hasAuthenticatedSession {
    return _ref.read(authenticatedSessionProvider) != null;
  }
}
