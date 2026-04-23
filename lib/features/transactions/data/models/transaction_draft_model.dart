import '../../domain/entities/transaction_draft.dart';

class TransactionDraftModel extends TransactionDraft {
  const TransactionDraftModel({
    required super.walletId,
    required super.type,
    required super.amount,
    required super.percent,
    required super.externalTransactionId,
    required super.occurredAt,
    required super.phoneNumber,
    required super.cash,
    super.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'walletId': walletId,
      'type': switch (type) {
        TransactionEntryType.credit => 'CREDIT',
        TransactionEntryType.debit => 'DEBIT',
        TransactionEntryType.unknown => 'UNKNOWN',
      },
      'amount': amount,
      // TODO: Confirm backend contract history: older request examples used
      // `fee`, while the current create screen and response contract use
      // `percent`.
      'percent': percent,
      'externalTransactionId': externalTransactionId,
      'occurredAt': _formatOccurredAt(occurredAt),
      'phoneNumber': phoneNumber,
      'cash': cash,
      'description': description?.trim() ?? '',
    };
  }

  String _formatOccurredAt(DateTime value) {
    final local = value.toLocal();
    final year = local.year.toString().padLeft(4, '0');
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    final second = local.second.toString().padLeft(2, '0');
    return '$year-$month-${day}T$hour:$minute:$second';
  }
}
