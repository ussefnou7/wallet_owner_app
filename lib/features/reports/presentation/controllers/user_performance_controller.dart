import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/user_performance_filters.dart';
import '../../domain/entities/user_performance_response.dart';
import '../../domain/repositories/user_performance_repository.dart';

final userPerformanceControllerProvider =
    StateNotifierProvider.autoDispose<
      UserPerformanceController,
      UserPerformanceState
    >((ref) {
      final repository = ref.watch(userPerformanceRepositoryProvider);
      ref.watch(sessionScopeKeyProvider);
      return UserPerformanceController(repository, ref);
    });

class UserPerformanceState {
  UserPerformanceState({
    required this.filters,
    this.response,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  factory UserPerformanceState.initial() {
    return UserPerformanceState(
      filters: UserPerformanceFilters.currentMonth(),
      isLoading: true,
    );
  }

  factory UserPerformanceState.unauthenticated() {
    return UserPerformanceState(filters: UserPerformanceFilters.currentMonth());
  }

  final UserPerformanceFilters filters;
  final UserPerformanceResponse? response;
  final bool isLoading;
  final bool isRefreshing;
  final AppException? error;

  UserPerformanceState copyWith({
    UserPerformanceFilters? filters,
    UserPerformanceResponse? response,
    bool? isLoading,
    bool? isRefreshing,
    AppException? error,
    bool clearResponse = false,
    bool clearError = false,
  }) {
    return UserPerformanceState(
      filters: filters ?? this.filters,
      response: clearResponse ? null : response ?? this.response,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class UserPerformanceController extends StateNotifier<UserPerformanceState> {
  UserPerformanceController(this._repository, this._ref)
    : super(
        _ref.read(authenticatedSessionProvider) == null
            ? UserPerformanceState.unauthenticated()
            : UserPerformanceState.initial(),
      ) {
    if (_hasAuthenticatedSession) {
      unawaited(_load(filters: state.filters, keepExistingData: false));
    }
  }

  final UserPerformanceRepository _repository;
  final Ref _ref;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> applyFilters(UserPerformanceFilters filters) async {
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
    await applyFilters(UserPerformanceFilters.currentMonth());
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
    required UserPerformanceFilters filters,
    required bool keepExistingData,
  }) async {
    if (!_hasAuthenticatedSession) {
      state = UserPerformanceState(
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
      final response = await _repository.getUserPerformance(filters: filters);
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
