import 'package:equatable/equatable.dart';

class SupportTicketItem extends Equatable {
  const SupportTicketItem({
    required this.ticketId,
    required this.tenantId,
    required this.createdBy,
    required this.subject,
    required this.description,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.resolvedAt,
    this.resolvedBy,
  });

  final String ticketId;
  final String tenantId;
  final String createdBy;
  final String subject;
  final String description;
  final String priority;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? resolvedAt;
  final String? resolvedBy;

  @override
  List<Object?> get props => [
    ticketId,
    tenantId,
    createdBy,
    subject,
    description,
    priority,
    status,
    createdAt,
    updatedAt,
    resolvedAt,
    resolvedBy,
  ];
}
