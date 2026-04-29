import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/renewal_request_payload.dart';
import '../../domain/repositories/renewal_requests_repository.dart';

final renewalControllerProvider =
    StateNotifierProvider<RenewalController, RenewalState>((ref) {
      final repository = ref.watch(renewalRequestsRepositoryProvider);
      return RenewalController(repository);
    });

class RenewalState {
  const RenewalState({this.isSubmitting = false, this.error});

  final bool isSubmitting;
  final AppException? error;

  RenewalState copyWith({bool? isSubmitting, AppException? error, bool clearError = false}) {
    return RenewalState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class RenewalController extends StateNotifier<RenewalState> {
  RenewalController(this._repository) : super(const RenewalState());

  final RenewalRequestsRepository _repository;

  Future<bool> createRenewalRequest(RenewalRequestPayload payload) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _repository.createRenewalRequest(payload);
      state = state.copyWith(isSubmitting: false);
      return true;
    } on AppException catch (e) {
      state = state.copyWith(isSubmitting: false, error: e);
      return false;
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: AppException(
          code: 'UNKNOWN_ERROR',
          message: e.toString(),
        ),
      );
      return false;
    }
  }
}
