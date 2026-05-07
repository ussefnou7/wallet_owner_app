import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/profit_summary_filters.dart';
import '../../domain/entities/profit_summary_response.dart';
import '../../domain/repositories/profit_summary_repository.dart';

final profitSummaryControllerProvider =
    StateNotifierProvider.autoDispose<
      ProfitSummaryController,
      ProfitSummaryState
    >((ref) {
      final repository = ref.watch(profitSummaryRepositoryProvider);
      ref.watch(sessionScopeKeyProvider);
      return ProfitSummaryController(repository, ref);
    });

class ProfitSummaryState {
  ProfitSummaryState({
    required this.filters,
    this.response,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  factory ProfitSummaryState.initial() {
    return ProfitSummaryState(
      filters: ProfitSummaryFilters.currentMonth(),
      isLoading: true,
    );
  }

  factory ProfitSummaryState.unauthenticated() {
    return ProfitSummaryState(filters: ProfitSummaryFilters.currentMonth());
  }

  final ProfitSummaryFilters filters;
  final ProfitSummaryResponse? response;
  final bool isLoading;
  final bool isRefreshing;
  final AppException? error;

  ProfitSummaryState copyWith({
    ProfitSummaryFilters? filters,
    ProfitSummaryResponse? response,
    bool? isLoading,
    bool? isRefreshing,
    AppException? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return ProfitSummaryState(
      filters: filters ?? this.filters,
      response: clearResponse ? null : response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class ProfitSummaryController extends StateNotifier<ProfitSummaryState> {
  ProfitSummaryController(this._repository, this._ref)
    : super(
        _ref.read(authenticatedSessionProvider) == null
            ? ProfitSummaryState.unauthenticated()
            : ProfitSummaryState.initial(),
      ) {
    if (_hasAuthenticatedSession) {
      unawaited(_load(filters: state.filters, keepExistingData: false));
    }
  }

  final ProfitSummaryRepository _repository;
  final Ref _ref;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> applyFilters(ProfitSummaryFilters filters) async {
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
    await applyFilters(ProfitSummaryFilters.currentMonth());
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
    required ProfitSummaryFilters filters,
    required bool keepExistingData,
  }) async {
    if (!_hasAuthenticatedSession) {
      state = ProfitSummaryState(
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
      final response = await _repository.getProfitSummary(filters: filters);
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
