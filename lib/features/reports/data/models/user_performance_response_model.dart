import '../../../../core/errors/app_exception.dart';
import '../../domain/entities/user_performance_response.dart';

class UserPerformanceResponseModel extends UserPerformanceResponse {
  const UserPerformanceResponseModel({
    required super.summary,
    required super.users,
  });

  factory UserPerformanceResponseModel.fromJson(Map<String, dynamic> json) {
    final rawSummary = json['summary'];
    final summaryPayload = switch (rawSummary) {
      final Map<String, dynamic> value => value,
      _ => _looksLikeSummaryPayload(json) ? json : null,
    };

    if (summaryPayload == null) {
      throw const AppException(
        code: 'UNKNOWN_ERROR',
        message: 'Unexpected user performance response structure.',
      );
    }

    final rawUsers = json['users'];
    final users = rawUsers is List
        ? rawUsers
              .whereType<Map<String, dynamic>>()
              .map(UserPerformanceUserModel.fromJson)
              .toList(growable: false)
        : const <UserPerformanceUser>[];

    return UserPerformanceResponseModel(
      summary: UserPerformanceSummaryModel.fromJson(summaryPayload),
      users: users,
    );
  }
}

class UserPerformanceSummaryModel extends UserPerformanceSummary {
  const UserPerformanceSummaryModel({
    required super.activeUsers,
    required super.totalTransactions,
    required super.totalCredits,
    required super.totalDebits,
    required super.totalAmount,
    required super.totalUserProfit,
  });

  factory UserPerformanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return UserPerformanceSummaryModel(
      activeUsers: _asInt(json['activeUsers']),
      totalTransactions: _asInt(json['totalTransactions']),
      totalCredits: _asDouble(json['totalCredits']),
      totalDebits: _asDouble(json['totalDebits']),
      totalAmount: _asDouble(json['totalAmount']),
      totalUserProfit: _asDouble(json['totalUserProfit']),
    );
  }
}

class UserPerformanceUserModel extends UserPerformanceUser {
  const UserPerformanceUserModel({
    required super.userId,
    required super.username,
    required super.transactionCount,
    required super.creditCount,
    required super.debitCount,
    required super.totalCredits,
    required super.totalDebits,
    required super.totalAmount,
    required super.userProfit,
  });

  factory UserPerformanceUserModel.fromJson(Map<String, dynamic> json) {
    return UserPerformanceUserModel(
      userId: _stringOrFallback(json['userId'], '-'),
      username: _stringOrFallback(json['username'], '-'),
      transactionCount: _asInt(json['transactionCount']),
      creditCount: _asInt(json['creditCount']),
      debitCount: _asInt(json['debitCount']),
      totalCredits: _asDouble(json['totalCredits']),
      totalDebits: _asDouble(json['totalDebits']),
      totalAmount: _asDouble(json['totalAmount']),
      userProfit: _asDouble(json['userProfit']),
    );
  }
}

bool _looksLikeSummaryPayload(Map<String, dynamic> json) {
  return json.containsKey('activeUsers') ||
      json.containsKey('totalTransactions') ||
      json.containsKey('totalCredits') ||
      json.containsKey('totalDebits') ||
      json.containsKey('totalAmount') ||
      json.containsKey('totalUserProfit');
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

String _stringOrFallback(Object? value, String fallback) {
  if (value is! String) {
    return fallback;
  }
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return fallback;
  }
  return trimmed;
}
