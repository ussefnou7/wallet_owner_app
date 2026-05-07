import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../auth/domain/entities/session.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

final subscriptionExpiredControllerProvider = StateNotifierProvider.autoDispose<
    SubscriptionExpiredController, SubscriptionExpiredState>((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return SubscriptionExpiredController(authController: authController);
});

enum SubscriptionExpiredFeedback {
  renewalSent,
  renewalPending,
  stillExpired,
  reactivated,
  genericError,
}

class SubscriptionExpiredState {
  const SubscriptionExpiredState({
    this.isRechecking = false,
    this.feedback,
    this.error,
  });

  final bool isRechecking;
  final SubscriptionExpiredFeedback? feedback;
  final AppException? error;

  SubscriptionExpiredState copyWith({
    bool? isRechecking,
    Object? feedback = _sentinel,
    Object? error = _sentinel,
  }) {
    return SubscriptionExpiredState(
      isRechecking: isRechecking ?? this.isRechecking,
      feedback: identical(feedback, _sentinel)
          ? this.feedback
          : feedback as SubscriptionExpiredFeedback?,
      error: identical(error, _sentinel) ? this.error : error as AppException?,
    );
  }
}

class SubscriptionExpiredController
    extends StateNotifier<SubscriptionExpiredState> {
  SubscriptionExpiredController({required AuthController authController})
      : _authController = authController,
        super(const SubscriptionExpiredState());

  final AuthController _authController;

  void handleRenewalFlowResult(String? result) {
    if (result == _renewalSentResult) {
      state = state.copyWith(
        feedback: SubscriptionExpiredFeedback.renewalSent,
        error: null,
      );
      return;
    }

    if (result == _renewalPendingResult) {
      state = state.copyWith(
        feedback: SubscriptionExpiredFeedback.renewalPending,
        error: null,
      );
    }
  }

  Future<Session?> recheckStatus() async {
    if (state.isRechecking) {
      return null;
    }

    state = state.copyWith(isRechecking: true, feedback: null, error: null);

    try {
      final refreshedSession = await _authController.refreshSession();
      state = state.copyWith(
        isRechecking: false,
        feedback:
            refreshedSession != null && refreshedSession.isSubscriptionAllowed
                ? SubscriptionExpiredFeedback.reactivated
                : SubscriptionExpiredFeedback.stillExpired,
        error: null,
      );
      return refreshedSession;
    } on AppException catch (error) {
      state = state.copyWith(
        isRechecking: false,
        feedback: SubscriptionExpiredFeedback.genericError,
        error: error,
      );
      return null;
    }
  }

  void clearFeedback() {
    state = state.copyWith(feedback: null, error: null);
  }
}

const renewalSentNavigationResult = _renewalSentResult;
const renewalPendingNavigationResult = _renewalPendingResult;

const _renewalSentResult = 'renewal_sent';
const _renewalPendingResult = 'renewal_pending';
const _sentinel = Object();
