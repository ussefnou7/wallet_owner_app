import '../../domain/entities/support_ticket.dart';

class SupportTicketModel extends SupportTicket {
  const SupportTicketModel({
    required super.subject,
    required super.description,
    required super.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'description': description,
      'priority': priority.name.toUpperCase(),
    };
  }
}
