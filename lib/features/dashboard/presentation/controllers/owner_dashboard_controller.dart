import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../../domain/repositories/dashboard_repository.dart';

final ownerDashboardControllerProvider =
    StateNotifierProvider.autoDispose<
      OwnerDashboardController,
      OwnerDashboardState
    >((ref) {
      ref.watch(sessionScopeKeyProvider);
      final repository = ref.watch(dashboardRepositoryProvider);
      return OwnerDashboardController(repository: repository, ref: ref);
    });

class OwnerDashboardState {
  const OwnerDashboardState({
    required this.selectedPeriod,
    required this.overview,
    this.isLoading = false,
    this.isRefreshing = false,
    this.hasLoadedOnce = false,
    this.error,
  });

  factory OwnerDashboardState.initial() {
    return OwnerDashboardState(
      selectedPeriod: DashboardOverviewPeriod.daily,
      overview: OwnerDashboardOverview.empty(),
      isLoading: true,
    );
  }

  factory OwnerDashboardState.unauthenticated() {
    return OwnerDashboardState(
      selectedPeriod: DashboardOverviewPeriod.daily,
      overview: OwnerDashboardOverview.empty(),
    );
  }

  final DashboardOverviewPeriod selectedPeriod;
  final OwnerDashboardOverview overview;
  final bool isLoading;
  final bool isRefreshing;
  final bool hasLoadedOnce;
  final AppException? error;

  OwnerDashboardState copyWith({
    DashboardOverviewPeriod? selectedPeriod,
    OwnerDashboardOverview? overview,
    bool? isLoading,
    bool? isRefreshing,
    bool? hasLoadedOnce,
    AppException? error,
    bool clearError = false,
  }) {
    return OwnerDashboardState(
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      overview: overview ?? this.overview,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      hasLoadedOnce: hasLoadedOnce ?? this.hasLoadedOnce,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class OwnerDashboardController extends StateNotifier<OwnerDashboardState> {
  OwnerDashboardController({
    required DashboardRepository repository,
    required Ref ref,
  }) : _repository = repository,
       _ref = ref,
       super(
         ref.read(authenticatedSessionProvider) == null
             ? OwnerDashboardState.unauthenticated()
             : OwnerDashboardState.initial(),
       ) {
    if (_hasAuthenticatedSession) {
      unawaited(_load(period: state.selectedPeriod, keepExistingData: false));
    }
  }

  final DashboardRepository _repository;
  final Ref _ref;
  int _requestSequence = 0;
  int _latestRequestId = 0;

  Future<void> selectPeriod(DashboardOverviewPeriod period) async {
    if (period == state.selectedPeriod) {
      return;
    }

    state = state.copyWith(
      selectedPeriod: period,
      overview: state.hasLoadedOnce
          ? state.overview
          : OwnerDashboardOverview.empty(period: period),
      isLoading: !state.hasLoadedOnce,
      isRefreshing: state.hasLoadedOnce,
      clearError: true,
    );

    await _load(period: period, keepExistingData: state.hasLoadedOnce);
  }

  Future<void> refresh() async {
    await _load(period: state.selectedPeriod, keepExistingData: true);
  }

  Future<void> retry() async {
    await _load(
      period: state.selectedPeriod,
      keepExistingData: state.hasLoadedOnce,
    );
  }

  Future<void> _load({
    required DashboardOverviewPeriod period,
    required bool keepExistingData,
  }) async {
    if (!_hasAuthenticatedSession) {
      state = OwnerDashboardState(
        selectedPeriod: period,
        overview: OwnerDashboardOverview.empty(period: period),
      );
      return;
    }

    final requestId = ++_requestSequence;
    _latestRequestId = requestId;

    state = state.copyWith(
      selectedPeriod: period,
      isLoading: !keepExistingData,
      isRefreshing: keepExistingData,
      clearError: true,
    );

    try {
      final overview = await _repository.getOwnerOverview(period: period);
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        selectedPeriod: period,
        overview: overview,
        isLoading: false,
        isRefreshing: false,
        hasLoadedOnce: true,
        clearError: true,
      );
    } on AppException catch (error) {
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        selectedPeriod: period,
        isLoading: false,
        isRefreshing: false,
        error: error,
      );
    } catch (_) {
      if (requestId != _latestRequestId) {
        return;
      }

      state = state.copyWith(
        selectedPeriod: period,
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
