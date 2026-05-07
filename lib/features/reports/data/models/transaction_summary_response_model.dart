import '../../../../core/errors/app_exception.dart';
import '../../../transactions/domain/entities/transaction_draft.dart';
import '../../domain/entities/transaction_summary_response.dart';

class TransactionSummaryResponseModel extends TransactionSummaryResponse {
  const TransactionSummaryResponseModel({
    required super.summary,
    super.highestTransaction,
  });

  factory TransactionSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    final summaryPayload = switch (rawSummary) {
      final Map<String, dynamic> value => value,
      _ => _looksLikeSummaryPayload(json) ? json : null,
    };

    if (summaryPayload == null) {
      throw const AppException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected transaction summary response structure.',
      );
    }

    final rawHighestTransaction = json['highestTransaction'];

    return TransactionSummaryResponseModel(
      summary: TransactionSummarySummaryModel.fromJson(summaryPayload),
      highestTransaction: rawHighestTransaction is Map<String, dynamic>
          ? TransactionSummaryHighestTransactionModel.fromJson(
              rawHighestTransaction,
            )
          : null,
    );
  }
}

class TransactionSummarySummaryModel extends TransactionSummarySummary {
  const TransactionSummarySummaryModel({
    required super.totalCredits,
    required super.totalDebits,
    required super.transactionCount,
    required super.creditCount,
    required super.debitCount,
    required super.balanceScope,
    super.balance,
  });

  factory TransactionSummarySummaryModel.fromJson(Map<String, dynamic> json) {
    return TransactionSummarySummaryModel(
      totalCredits: _asDouble(json['totalCredits']),
      totalDebits: _asDouble(json['totalDebits']),
      transactionCount: _asInt(json['transactionCount']),
      creditCount: _asInt(json['creditCount']),
      debitCount: _asInt(json['debitCount']),
      balance: _asNullableDouble(json['balance']),
      balanceScope: _balanceScopeFromJson(json['balanceScope']),
    );
  }
}

class TransactionSummaryHighestTransactionModel
    extends TransactionSummaryHighestTransaction {
  const TransactionSummaryHighestTransactionModel({
    required super.id,
    required super.type,
    required super.amount,
    super.walletId,
    super.walletName,
    super.branchId,
    super.branchName,
    super.createdBy,
    super.createdByUsername,
    super.occurredAt,
    super.description,
  });

  factory TransactionSummaryHighestTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TransactionSummaryHighestTransactionModel(
      id: _stringOrFallback(json['id'], '-'),
      type: _transactionTypeFromJson(json['type']),
      amount: _asDouble(json['amount']),
      walletId: _stringOrNull(json['walletId']),
      walletName:
          _stringOrNull(json['walletName']) ?? _stringOrNull(json['walletId']),
      branchId: _stringOrNull(json['branchId']),
      branchName:
          _stringOrNull(json['branchName']) ?? _stringOrNull(json['branchId']),
      createdBy: _stringOrNull(json['createdBy']),
      createdByUsername: _stringOrNull(json['createdByUsername']),
      occurredAt: _dateTimeFromJson(json['occurredAt']),
      description: _stringOrNull(json['description']),
    );
  }
}

bool _looksLikeSummaryPayload(Map<String, dynamic> json) {
  return json.containsKey('totalCredits') ||
      json.containsKey('totalDebits') ||
      json.containsKey('transactionCount') ||
      json.containsKey('creditCount') ||
      json.containsKey('debitCount') ||
      json.containsKey('balanceScope');
}

double _asDouble(Object? value) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.trim()) ?? 0;
  }
  return 0;
}

double? _asNullableDouble(Object? value) {
  if (value == null) {
    return null;
  }
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value.trim());
  }
  return null;
}

int _asInt(Object? value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }
  return 0;
}

String _stringOrFallback(Object? value, String fallback) {
  final normalized = _stringOrNull(value);
  return normalized ?? fallback;
}

String? _stringOrNull(Object? value) {
  if (value is! String) {
    return null;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return trimmed;
}

DateTime? _dateTimeFromJson(Object? value) {
  if (value is String && value.trim().isNotEmpty) {
    return DateTime.tryParse(value.trim());
  }
  return null;
}

TransactionEntryType _transactionTypeFromJson(Object? value) {
  return switch (value) {
    'CREDIT' || 'credit' => TransactionEntryType.credit,
    'DEBIT' || 'debit' => TransactionEntryType.debit,
    _ => TransactionEntryType.unknown,
  };
}

BalanceScope _balanceScopeFromJson(Object? value) {
  return switch (value) {
    'WALLET' || 'wallet' => BalanceScope.wallet,
    'BRANCH' || 'branch' => BalanceScope.branch,
    _ => BalanceScope.none,
  };
}
