import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/support_ticket.dart';
import '../entities/support_ticket_item.dart';

final supportRepositoryProvider = Provider<SupportRepository>((ref) {
  throw UnimplementedError('supportRepositoryProvider must be overridden');
});

abstract interface class SupportRepository {
  Future<List<SupportTicketItem>> getMyTickets();

  Future<void> createTicket(SupportTicket ticket);
}
