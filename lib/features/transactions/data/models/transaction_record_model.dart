import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';

class TransactionRecordModel extends TransactionRecord {
  const TransactionRecordModel({
    required super.id,
    super.tenantId,
    required super.walletId,
    required super.walletName,
    super.externalTransactionId,
    required super.type,
    required super.amount,
    super.percent,
    super.phoneNumber,
    super.cash,
    required super.date,
    super.occurredAt,
    super.createdAt,
    super.updatedAt,
    required super.createdBy,
    super.createdByUsername,
    required super.status,
    super.note,
  });

  factory TransactionRecordModel.fromJson(Map<String, dynamic> json) {
    final occurredAt = _dateTimeFromJson(json['occurredAt']);
    final createdAt = _dateTimeFromJson(json['createdAt']);
    final updatedAt = _dateTimeFromJson(json['updatedAt']);
    final date = occurredAt ?? createdAt ?? DateTime.now();

    return TransactionRecordModel(
      id: json['id'] as String,
      tenantId: json['tenantId'] as String?,
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String? ?? json['walletId'] as String,
      externalTransactionId: json['externalTransactionId'] as String?,
      type: _transactionTypeFromJson(json['type'] as String?),
      amount: _doubleFromJson(json['amount']),
      percent: _doubleFromJson(json['percent']),
      phoneNumber: json['phoneNumber'] as String?,
      cash: json['cash'] as bool? ?? false,
      date: json['date'] is String
          ? DateTime.tryParse(json['date'] as String) ?? date
          : date,
      occurredAt: occurredAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      createdBy:
          json['createdBy'] as String? ??
          'Backend',
      createdByUsername: _stringOrNull(json['createdByUsername']),
      status: json['status'] is String
          ? _statusFromJson(json['status'] as String)
          : TransactionRecordStatus.recorded,
      note: json['description'] as String? ?? json['note'] as String?,
    );
  }
}

double _doubleFromJson(Object? value) {
  if (value is num) {
    return value.toDouble();
  }

  return 0;
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value is String && value.isNotEmpty) {
    return DateTime.tryParse(value);
  }

  return null;
}

String? _stringOrNull(Object? value) {
  if (value is! String) {
    return null;
  }

  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

TransactionEntryType _transactionTypeFromJson(String? value) {
  return switch (value) {
    'CREDIT' || 'credit' => TransactionEntryType.credit,
    'DEBIT' || 'debit' => TransactionEntryType.debit,
    _ => TransactionEntryType.unknown,
  };
}

TransactionRecordStatus _statusFromJson(String value) {
  return switch (value) {
    'pendingReview' ||
    'PENDING_REVIEW' => TransactionRecordStatus.pendingReview,
    _ => TransactionRecordStatus.recorded,
  };
}
