import '../../domain/entities/support_ticket_item.dart';

class SupportTicketItemModel extends SupportTicketItem {
  const SupportTicketItemModel({
    required super.ticketId,
    required super.tenantId,
    required super.createdBy,
    required super.subject,
    required super.description,
    required super.priority,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.resolvedAt,
    super.resolvedBy,
  });

  factory SupportTicketItemModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketItemModel(
      ticketId: json['ticketId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      createdBy: json['createdBy'] as String? ?? '',
      subject: json['subject'] as String? ?? '',
      description: json['description'] as String? ?? '',
      priority: json['priority'] as String? ?? '',
      status: json['status'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      resolvedAt: DateTime.tryParse(json['resolvedAt'] as String? ?? ''),
      resolvedBy: json['resolvedBy'] as String?,
    );
  }
}
