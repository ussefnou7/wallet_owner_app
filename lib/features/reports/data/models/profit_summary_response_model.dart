import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/profit_summary_response.dart';

class ProfitSummaryResponseModel extends ProfitSummaryResponse {
  const ProfitSummaryResponseModel({required super.summary});

  factory ProfitSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    final summaryPayload = switch (rawSummary) {
      final Map<String, dynamic> value => value,
      _ => _looksLikeSummaryPayload(json) ? json : null,
    };

    if (summaryPayload == null) {
      throw const AppException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected profit summary response structure.',
      );
    }

    return ProfitSummaryResponseModel(
      summary: ProfitSummarySummaryModel.fromJson(summaryPayload),
    );
  }
}

class ProfitSummarySummaryModel extends ProfitSummarySummary {
  const ProfitSummarySummaryModel({
    required super.totalProfits,
    required super.totalCollectedProfit,
    required super.totalUncollectedProfit,
    required super.totalBalance,
    required super.walletsWithCurrentProfit,
    required super.totalActiveWallets,
  });

  factory ProfitSummarySummaryModel.fromJson(Map<String, dynamic> json) {
    return ProfitSummarySummaryModel(
      totalProfits: _asDouble(json['totalProfits']),
      totalCollectedProfit: _asDouble(json['totalCollectedProfit']),
      totalUncollectedProfit: _asDouble(json['totalUncollectedProfit']),
      totalBalance: _asDouble(json['totalBalance']),
      walletsWithCurrentProfit: _asInt(json['walletsWithCurrentProfit']),
      totalActiveWallets: _asInt(json['totalActiveWallets']),
    );
  }
}

bool _looksLikeSummaryPayload(Map<String, dynamic> json) {
  return json.containsKey('totalProfits') ||
      json.containsKey('totalCollectedProfit') ||
      json.containsKey('totalUncollectedProfit') ||
      json.containsKey('totalBalance') ||
      json.containsKey('walletsWithCurrentProfit') ||
      json.containsKey('totalActiveWallets');
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

int _asInt(Object? value) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value.trim()) ?? 0;
  }
  return 0;
}
