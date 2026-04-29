import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/support_ticket.dart';
import '../../domain/repositories/support_repository.dart';

final supportControllerProvider =
    StateNotifierProvider<SupportController, SupportState>((ref) {
      final repository = ref.watch(supportRepositoryProvider);
      return SupportController(repository);
    });

class SupportState {
  const SupportState({this.isSubmitting = false, this.error});

  final bool isSubmitting;
  final AppException? error;

  SupportState copyWith({bool? isSubmitting, AppException? error, bool clearError = false}) {
    return SupportState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class SupportController extends StateNotifier<SupportState> {
  SupportController(this._repository) : super(const SupportState());

  final SupportRepository _repository;

  Future<bool> createTicket(SupportTicket ticket) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _repository.createTicket(ticket);
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
