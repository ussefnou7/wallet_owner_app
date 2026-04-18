import '../../domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_record.dart';

class TransactionRecordModel extends TransactionRecord {
  const TransactionRecordModel({
    required super.id,
    required super.walletId,
    required super.walletName,
    required super.type,
    required super.amount,
    required super.date,
    required super.createdBy,
    required super.status,
    super.note,
  });

  factory TransactionRecordModel.fromJson(Map<String, dynamic> json) {
    return TransactionRecordModel(
      id: json['id'] as String,
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String,
      type: TransactionEntryType.values.byName(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      createdBy: json['createdBy'] as String,
      status: TransactionRecordStatus.values.byName(json['status'] as String),
      note: json['note'] as String?,
    );
  }
}
