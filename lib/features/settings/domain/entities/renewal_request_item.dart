import 'package:equatable/equatable.dart';

class RenewalRequestItem extends Equatable {
  const RenewalRequestItem({
    required this.requestId,
    required this.tenantId,
    required this.requestedBy,
    required this.phoneNumber,
    required this.amount,
    required this.periodMonths,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.adminNote,
  });

  final String requestId;
  final String tenantId;
  final String requestedBy;
  final String phoneNumber;
  final double amount;
  final int periodMonths;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final String? adminNote;

  @override
  List<Object?> get props => [
    requestId,
    tenantId,
    requestedBy,
    phoneNumber,
    amount,
    periodMonths,
    status,
    createdAt,
    updatedAt,
    reviewedAt,
    reviewedBy,
    adminNote,
  ];
}
