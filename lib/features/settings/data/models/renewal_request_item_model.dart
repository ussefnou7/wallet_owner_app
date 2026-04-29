import '../../domain/entities/renewal_request_item.dart';

class RenewalRequestItemModel extends RenewalRequestItem {
  const RenewalRequestItemModel({
    required super.requestId,
    required super.tenantId,
    required super.requestedBy,
    required super.phoneNumber,
    required super.amount,
    required super.periodMonths,
    required super.status,
    required super.createdAt,
    required super.updatedAt,
    super.reviewedAt,
    super.reviewedBy,
    super.adminNote,
  });

  factory RenewalRequestItemModel.fromJson(Map<String, dynamic> json) {
    return RenewalRequestItemModel(
      requestId: json['requestId'] as String? ?? '',
      tenantId: json['tenantId'] as String? ?? '',
      requestedBy: json['requestedBy'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      periodMonths: (json['periodMonths'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt:
          DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      reviewedAt: DateTime.tryParse(json['reviewedAt'] as String? ?? ''),
      reviewedBy: json['reviewedBy'] as String?,
      adminNote: json['adminNote'] as String?,
    );
  }
}
