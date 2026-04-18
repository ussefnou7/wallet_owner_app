import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_submission_result.dart';
import '../../domain/repositories/transactions_repository.dart';

final createTransactionControllerProvider =
    StateNotifierProvider<CreateTransactionController, CreateTransactionState>((
      ref,
    ) {
      final repository = ref.watch(transactionsRepositoryProvider);
      return CreateTransactionController(repository);
    });

class CreateTransactionState {
  const CreateTransactionState({
    this.isSubmitting = false,
    this.errorMessage,
    this.lastResult,
  });

  final bool isSubmitting;
  final String? errorMessage;
  final TransactionSubmissionResult? lastResult;

  CreateTransactionState copyWith({
    bool? isSubmitting,
    String? errorMessage,
    TransactionSubmissionResult? lastResult,
    bool clearError = false,
    bool clearResult = false,
  }) {
    return CreateTransactionState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      lastResult: clearResult ? null : lastResult ?? this.lastResult,
    );
  }
}

class CreateTransactionController
    extends StateNotifier<CreateTransactionState> {
  CreateTransactionController(this._repository)
    : super(const CreateTransactionState());

  final TransactionsRepository _repository;

  Future<bool> submit(TransactionDraft draft) async {
    state = state.copyWith(
      isSubmitting: true,
      clearError: true,
      clearResult: true,
    );

    try {
      final result = await _repository.submitTransaction(draft);
      state = state.copyWith(isSubmitting: false, lastResult: result);
      return true;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: 'Unable to save the transaction. Please try again.',
      );
      return false;
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearError: true, clearResult: true);
  }
}
