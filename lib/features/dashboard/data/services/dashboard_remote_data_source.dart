import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../../../core/network/network_constants.dart';
import '../../domain/entities/dashboard_overview.dart';
import '../../domain/entities/dashboard_transaction_summary.dart';
import '../../domain/entities/owner_dashboard_overview.dart';
import '../../domain/entities/user_dashboard_overview.dart';

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

  Future<ApiResult<OwnerDashboardOverview>> getOwnerOverview({
    required DashboardOverviewPeriod period,
  });

  Future<ApiResult<UserDashboardOverview>> getUserOverview({
    required DashboardOverviewPeriod period,
  });

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
        queryParameters: {'period': DashboardOverviewPeriod.daily.apiValue},
      );
      final data = _extractObjectData(response.data);
      final ownerOverview = _mapOwnerOverview(
        data,
        requestedPeriod: DashboardOverviewPeriod.daily,
      );
      return ApiSuccess(_mapLegacyOverview(ownerOverview));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<OwnerDashboardOverview>> getOwnerOverview({
    required DashboardOverviewPeriod period,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsDashboardOverviewPath,
        queryParameters: {'period': period.apiValue},
      );
      final data = _extractObjectData(response.data);
      return ApiSuccess(_mapOwnerOverview(data, requestedPeriod: period));
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  @override
  Future<ApiResult<UserDashboardOverview>> getUserOverview({
    required DashboardOverviewPeriod period,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        NetworkConstants.reportsUserDashboardPath,
        queryParameters: {'period': period.apiValue},
      );
      final data = _extractObjectData(response.data);
      return ApiSuccess(_mapUserOverview(data, requestedPeriod: period));
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

  OwnerDashboardOverview _mapOwnerOverview(
    Map<String, dynamic> data, {
    required DashboardOverviewPeriod requestedPeriod,
  }) {
    final profitSnapshot = _readObject(data['profitSnapshot']);
    final walletHealth = _readObject(data['walletHealth']);
    final attentionItems =
        (walletHealth['attentionItems'] as List?)
            ?.whereType<Map>()
            .map(_normalizeMap)
            .map(_mapAttentionItem)
            .toList(growable: false) ??
        const <DashboardWalletAttentionItem>[];
    final responsePeriod = data['period'];

    return OwnerDashboardOverview(
      period: responsePeriod is String && responsePeriod.trim().isNotEmpty
          ? DashboardOverviewPeriodX.fromApiValue(responsePeriod)
          : requestedPeriod,
      profitSnapshot: DashboardProfitSnapshot(
        totalProfit: _asDouble(profitSnapshot['totalProfit']),
        totalCollectedProfit: _asDouble(profitSnapshot['totalCollectedProfit']),
        totalUncollectedProfit: _asDouble(
          profitSnapshot['totalUncollectedProfit'],
        ),
        totalTransactions: _asInt(profitSnapshot['totalTransactions']),
        totalTransactionVolume: _asDouble(
          profitSnapshot['totalTransactionVolume'],
        ),
      ),
      walletHealth: DashboardWalletHealth(
        totalWallets: _asInt(walletHealth['totalWallets']),
        activeWallets: _asInt(walletHealth['activeWallets']),
        inactiveWallets: _asInt(walletHealth['inactiveWallets']),
        activeWalletsBalance: _asDouble(walletHealth['activeWalletsBalance']),
        nearDailyLimitCount: _asInt(walletHealth['nearDailyLimitCount']),
        nearMonthlyLimitCount: _asInt(walletHealth['nearMonthlyLimitCount']),
        limitReachedCount: _asInt(walletHealth['limitReachedCount']),
        walletsNeedAttentionCount: _asInt(
          walletHealth['walletsNeedAttentionCount'],
        ),
        healthStatus: DashboardHealthStatusX.fromApiValue(
          walletHealth['healthStatus'] as String?,
        ),
        attentionItems: attentionItems,
      ),
    );
  }

  DashboardOverview _mapLegacyOverview(OwnerDashboardOverview overview) {
    return DashboardOverview(
      totalBalance: overview.walletHealth.activeWalletsBalance,
      activeWallets: overview.walletHealth.activeWallets,
      totalCredits: overview.profitSnapshot.totalCollectedProfit,
      totalDebits: overview.profitSnapshot.totalUncollectedProfit,
      netAmount: overview.profitSnapshot.totalProfit,
      transactionCount: overview.profitSnapshot.totalTransactions,
      metrics: [
        DashboardOverviewMetric(
          key: 'totalTransactionVolume',
          label: 'Total Transaction Volume',
          value: overview.profitSnapshot.totalTransactionVolume,
          displayType: DashboardMetricDisplayType.amount,
        ),
        DashboardOverviewMetric(
          key: 'inactiveWallets',
          label: 'Inactive Wallets',
          value: overview.walletHealth.inactiveWallets,
          displayType: DashboardMetricDisplayType.count,
        ),
        DashboardOverviewMetric(
          key: 'walletsNeedAttentionCount',
          label: 'Wallets Needing Attention',
          value: overview.walletHealth.walletsNeedAttentionCount,
          displayType: DashboardMetricDisplayType.count,
        ),
      ],
    );
  }

  UserDashboardOverview _mapUserOverview(
    Map<String, dynamic> data, {
    required DashboardOverviewPeriod requestedPeriod,
  }) {
    final myActivity = _readObject(data['myActivity']);
    final branchWallets = _readObject(data['branchWallets']);
    final walletConsumptions =
        (data['walletConsumptions'] as List?)
            ?.whereType<Map>()
            .map(_normalizeMap)
            .map(_mapWalletConsumption)
            .toList(growable: false) ??
        const <UserDashboardWalletConsumption>[];
    final responsePeriod = data['period'];

    return UserDashboardOverview(
      period: responsePeriod is String && responsePeriod.trim().isNotEmpty
          ? DashboardOverviewPeriodX.fromApiValue(responsePeriod)
          : requestedPeriod,
      myActivity: UserDashboardActivity(
        totalCredits: _asDouble(myActivity['totalCredits']),
        totalDebits: _asDouble(myActivity['totalDebits']),
        transactionsVolume: _asDouble(myActivity['transactionsVolume']),
        transactionsCount: _asInt(myActivity['transactionsCount']),
        totalProfit: _asDouble(myActivity['totalProfit']),
      ),
      branchWallets: UserDashboardBranchWallets(
        walletsCount: _asInt(branchWallets['walletsCount']),
        totalBalance: _asDouble(branchWallets['totalBalance']),
        totalWalletProfit: _asDouble(branchWallets['totalWalletProfit']),
        totalCashProfit: _asDouble(branchWallets['totalCashProfit']),
        totalProfit: _asDouble(branchWallets['totalProfit']),
        nearLimitWalletsCount: _asInt(branchWallets['nearLimitWalletsCount']),
      ),
      walletConsumptions: walletConsumptions,
    );
  }

  UserDashboardWalletConsumption _mapWalletConsumption(
    Map<String, dynamic> item,
  ) {
    return UserDashboardWalletConsumption(
      walletId: '${item['walletId'] ?? ''}',
      walletName: '${item['walletName'] ?? ''}',
      branchName: _asNullableString(item['branchName']),
      dailyPercent: _asDouble(item['dailyPercent']),
      monthlyPercent: _asDouble(item['monthlyPercent']),
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

  Map<String, dynamic> _readObject(Object? value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is Map) {
      return _normalizeMap(value);
    }
    return const <String, dynamic>{};
  }

  DashboardWalletAttentionItem _mapAttentionItem(Map<String, dynamic> item) {
    return DashboardWalletAttentionItem(
      walletId: '${item['walletId'] ?? ''}',
      walletName: '${item['walletName'] ?? ''}',
      branchName: _asNullableString(item['branchName']),
      type: '${item['type'] ?? ''}',
      severity: DashboardAttentionSeverityX.fromApiValue(
        item['severity'] as String?,
      ),
      currentPercent: _asDouble(item['currentPercent']),
      message: '${item['message'] ?? ''}',
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

  String? _asNullableString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Map<String, dynamic> _normalizeMap(Map<dynamic, dynamic> map) {
    return map.map((key, value) => MapEntry('$key', value));
  }
}
