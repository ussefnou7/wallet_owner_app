import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
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
  final AppException? errorMessage;
  final TransactionSubmissionResult? lastResult;

  CreateTransactionState copyWith({
    bool? isSubmitting,
    AppException? errorMessage,
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
    } on AppException catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error,
      );
      return false;
    }
  }

  void clearFeedback() {
    state = state.copyWith(clearError: true, clearResult: true);
  }
}
