import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/dashboard_transaction_summary.dart';

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioDashboardRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class DashboardRemoteDataSource {
  Future<ApiResult<DashboardOverview>> getOverview();

  Future<ApiResult<DashboardTransactionSummary>> getTransactionSummary({
    required DateTime fromDate,
    required DateTime toDate,
  });
}

class DioDashboardRemoteDataSource implements DashboardRemoteDataSource {
  DioDashboardRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<DashboardOverview>> getOverview() async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsDashboardOverviewPath,
      );
      final data = _extractObjectData(response.data);
      return ApiSuccess(_mapOverview(data));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<DashboardTransactionSummary>> getTransactionSummary({
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsTransactionsSummaryPath,
        queryParameters: {
          'fromDate': fromDate.toIso8601String(),
          'toDate': toDate.toIso8601String(),
        },
      );
      final data = _extractObjectData(response.data);
      return ApiSuccess(
        DashboardTransactionSummary(
          totalCredits: _asDouble(data['totalCredits']),
          totalDebits: _asDouble(data['totalDebits']),
          netAmount: _asDouble(data['netAmount']),
          transactionCount: _asInt(data['transactionCount']),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  DashboardOverview _mapOverview(Map<String, dynamic> data) {
    final totalBalance = _pickFirstDouble(data, const [
      'totalBalance',
      'balance',
      'currentBalance',
      'netBalance',
    ]);
    final activeWallets = _pickFirstInt(data, const [
      'activeWallets',
      'walletCount',
      'totalWallets',
    ]);
    final totalCredits = _pickFirstDouble(data, const ['totalCredits']);
    final totalDebits = _pickFirstDouble(data, const ['totalDebits']);
    final netAmount = _pickFirstDouble(data, const ['netAmount']);
    final transactionCount = _pickFirstInt(data, const ['transactionCount']);
    final hiddenKeys = <String>{
      'totalBalance',
      'balance',
      'currentBalance',
      'netBalance',
      'activeWallets',
      'walletCount',
      'totalWallets',
      'totalCredits',
      'totalDebits',
      'netAmount',
      'transactionCount',
      'title',
      'titleKey',
      'subtitle',
      'description',
      'content',
      'items',
      'results',
      'data',
      'result',
      'item',
    };

    final metrics = <DashboardOverviewMetric>[];
    for (final entry in data.entries) {
      if (hiddenKeys.contains(entry.key)) {
        continue;
      }
      final value = _normalizeMetricValue(entry.value);
      if (value == null) {
        continue;
      }
      metrics.add(
        DashboardOverviewMetric(
          key: entry.key,
          label: _humanizeKey(entry.key),
          value: value,
          displayType: _metricDisplayType(entry.key, value),
        ),
      );
    }

    metrics.sort((first, second) => first.label.compareTo(second.label));

    return DashboardOverview(
      totalBalance: totalBalance,
      activeWallets: activeWallets,
      totalCredits: totalCredits,
      totalDebits: totalDebits,
      netAmount: netAmount,
      transactionCount: transactionCount,
      metrics: metrics,
    );
  }

  Map<String, dynamic> _extractObjectData(Object? payload) {
    if (payload is Map<String, dynamic>) {
      for (final key in const ['data', 'result', 'item', 'content']) {
        final value = payload[key];
        if (value is Map<String, dynamic>) {
          return _extractObjectData(value);
        }
      }

      return payload;
    }

    throw const AppException(
      code: 'UNKNOWN_ERROR',
      message: 'Unexpected dashboard report response structure.',
    );
  }

  double _asDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }

  int _asInt(Object? value) {
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  double _pickFirstDouble(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      if (data.containsKey(key)) {
        return _asDouble(data[key]);
      }
    }
    return 0;
  }

  int _pickFirstInt(Map<String, dynamic> data, List<String> keys) {
    for (final key in keys) {
      if (data.containsKey(key)) {
        return _asInt(data[key]);
      }
    }
    return 0;
  }

  Object? _normalizeMetricValue(Object? value) {
    if (value == null) {
      return null;
    }
    if (value is num || value is bool) {
      return value;
    }
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      return trimmed;
    }
    return null;
  }

  DashboardMetricDisplayType _metricDisplayType(String key, Object value) {
    final normalizedKey = key.toLowerCase();
    if (value is bool) {
      return DashboardMetricDisplayType.boolean;
    }
    if (normalizedKey.contains('percent') || normalizedKey.endsWith('rate')) {
      return DashboardMetricDisplayType.percent;
    }
    if (value is num) {
      if (normalizedKey.contains('count') ||
          normalizedKey.startsWith('total') &&
              normalizedKey.contains('transaction') ||
          normalizedKey.contains('wallets')) {
        return DashboardMetricDisplayType.count;
      }
      return DashboardMetricDisplayType.amount;
    }
    return DashboardMetricDisplayType.text;
  }

  String _humanizeKey(String key) {
    final buffer = StringBuffer();
    for (var index = 0; index < key.length; index++) {
      final character = key[index];
      final isSeparator = character == '_' || character == '-';
      if (isSeparator) {
        buffer.write(' ');
        continue;
      }
      final isUppercase =
          character.toUpperCase() == character &&
          character.toLowerCase() != character;
      if (index > 0 && isUppercase && key[index - 1] != ' ') {
        buffer.write(' ');
      }
      buffer.write(character);
    }
    final words = buffer
        .toString()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .toList();
    return words.join(' ');
  }
}
