import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../../domain/entities/user_dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';

final userDashboardControllerProvider =
    StateNotifierProvider.autoDispose<
      UserDashboardController,
      UserDashboardState
    >((ref) {
      ref.watch(sessionScopeKeyProvider);
      final repository = ref.watch(dashboardRepositoryProvider);
      return UserDashboardController(repository: repository, ref: ref);
    });

class UserDashboardState {
  const UserDashboardState({
    required this.selectedPeriod,
    required this.cache,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasLoadedOnce = false,
    this.error,
  });

  factory UserDashboardState.initial() {
    return const UserDashboardState(
      selectedPeriod: DashboardOverviewPeriod.daily,
      cache: <DashboardOverviewPeriod, UserDashboardOverview>{},
      isLoading: true,
    );
  }

  factory UserDashboardState.unauthenticated() {
    return const UserDashboardState(
      selectedPeriod: DashboardOverviewPeriod.daily,
      cache: <DashboardOverviewPeriod, UserDashboardOverview>{},
    );
  }

  final DashboardOverviewPeriod selectedPeriod;
  final Map<DashboardOverviewPeriod, UserDashboardOverview> cache;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasLoadedOnce;
  final AppException? error;

  UserDashboardOverview get overview =>
      cache[selectedPeriod] ??
      UserDashboardOverview.empty(period: selectedPeriod);

  bool get hasCachedSelectedPeriod => cache.containsKey(selectedPeriod);

  UserDashboardState copyWith({
    DashboardOverviewPeriod? selectedPeriod,
    Map<DashboardOverviewPeriod, UserDashboardOverview>? cache,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasLoadedOnce,
    AppException? error,
    bool clearError = false,
  }) {
    return UserDashboardState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      cache: cache ?? this.cache,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class UserDashboardController extends StateNotifier<UserDashboardState> {
  UserDashboardController({
    required DashboardRepository repository,
    required Ref ref,
  }) : _repository = repository,
       _ref = ref,
       super(
         ref.read(authenticatedSessionProvider) == null
             ? UserDashboardState.unauthenticated()
             : UserDashboardState.initial(),
       ) {
    if (_hasAuthenticatedSession) {
      unawaited(loadInitial());
    }
  }

  final DashboardRepository _repository;
  final Ref _ref;
  final Map<DashboardOverviewPeriod, Future<void>> _inFlightRequests = {};

  Future<void> loadInitial() async {
    if (state.hasLoadedOnce) {
      return;
    }

    await _load(period: state.selectedPeriod, force: false);
  }

  Future<void> selectPeriod(DashboardOverviewPeriod period) async {
    if (period == state.selectedPeriod && state.hasCachedSelectedPeriod) {
      return;
    }

    final hasCachedPeriod = state.cache.containsKey(period);
    state = state.copyWith(
      selectedPeriod: period,
      isLoading: !hasCachedPeriod,
      isRefreshing: false,
      clearError: true,
    );

    if (hasCachedPeriod) {
      return;
    }

    await _load(period: period, force: false);
  }

  Future<void> refresh() async {
    await _load(period: state.selectedPeriod, force: true);
  }

  Future<void> retry() async {
    await _load(period: state.selectedPeriod, force: true);
  }

  Future<void> _load({
    required DashboardOverviewPeriod period,
    required bool force,
  }) {
    if (!_hasAuthenticatedSession) {
      state = UserDashboardState.unauthenticated();
      return Future.value();
    }

    if (!force && state.cache.containsKey(period)) {
      if (period == state.selectedPeriod) {
        state = state.copyWith(
          isLoading: false,
          isRefreshing: false,
          hasLoadedOnce: true,
          clearError: true,
        );
      }
      return Future.value();
    }

    final activeRequest = _inFlightRequests[period];
    if (activeRequest != null) {
      return activeRequest;
    }

    if (period == state.selectedPeriod) {
      final hasExistingData = state.cache.containsKey(period);
      state = state.copyWith(
        isLoading: !hasExistingData,
        isRefreshing: hasExistingData,
        clearError: true,
      );
    }

    final future = _performLoad(period: period);
    _inFlightRequests[period] = future;
    return future.whenComplete(() {
      if (identical(_inFlightRequests[period], future)) {
        _inFlightRequests.remove(period);
      }
    });
  }

  Future<void> _performLoad({required DashboardOverviewPeriod period}) async {
    try {
      final overview = await _repository.getUserOverview(period: period);
      final updatedCache =
          Map<DashboardOverviewPeriod, UserDashboardOverview>.of(state.cache)
            ..[period] = overview;

      state = state.copyWith(
        selectedPeriod: state.selectedPeriod,
        cache: updatedCache,
        isLoading: period == state.selectedPeriod ? false : state.isLoading,
        isRefreshing: period == state.selectedPeriod
            ? false
            : state.isRefreshing,
        hasLoadedOnce: updatedCache.isNotEmpty,
        clearError: period == state.selectedPeriod,
      );
    } on AppException catch (error) {
      if (period != state.selectedPeriod) {
        return;
      }

      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    } catch (_) {
      if (period != state.selectedPeriod) {
        return;
      }

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
