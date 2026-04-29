import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/support_ticket_item.dart';
import '../../domain/repositories/support_repository.dart';

final supportTicketsControllerProvider =
    AsyncNotifierProvider<SupportTicketsController, List<SupportTicketItem>>(
      SupportTicketsController.new,
    );

class SupportTicketsController extends AsyncNotifier<List<SupportTicketItem>> {
  @override
  Future<List<SupportTicketItem>> build() async {
    final repository = ref.watch(supportRepositoryProvider);
    return repository.getMyTickets();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(supportRepositoryProvider);
      return repository.getMyTickets();
    });
  }
}
