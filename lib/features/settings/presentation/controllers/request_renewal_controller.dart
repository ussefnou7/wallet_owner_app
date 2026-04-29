import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/renewal_request.dart';
import '../../domain/entities/renewal_request_result.dart';
import '../../domain/repositories/renewal_requests_repository.dart';

final requestRenewalControllerProvider =
    StateNotifierProvider<RequestRenewalController, RequestRenewalState>((ref) {
      final repository = ref.watch(renewalRequestsRepositoryProvider);
      return RequestRenewalController(repository);
    });

class RequestRenewalState {
  const RequestRenewalState({
    this.isSubmitting = false,
    this.lastResult,
    this.errorMessage,
  });

  final bool isSubmitting;
  final RenewalRequestResult? lastResult;
  final AppException? errorMessage;

  RequestRenewalState copyWith({
    bool? isSubmitting,
    RenewalRequestResult? lastResult,
    AppException? errorMessage,
    bool clearLastResult = false,
    bool clearErrorMessage = false,
  }) {
    return RequestRenewalState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastResult: clearLastResult ? null : lastResult ?? this.lastResult,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}

class RequestRenewalController extends StateNotifier<RequestRenewalState> {
  RequestRenewalController(this._repository)
    : super(const RequestRenewalState());

  final RenewalRequestsRepository _repository;

  Future<bool> submit(RenewalRequest request) async {
    state = state.copyWith(
      isSubmitting: true,
      clearErrorMessage: true,
      clearLastResult: true,
    );

    try {
      final result = await _repository.submitRequest(request);
      state = state.copyWith(isSubmitting: false, lastResult: result);
      return true;
    } on AppException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error,
      );
      return false;
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearErrorMessage: true, clearLastResult: true);
  }
}
