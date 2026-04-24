import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_exception_mapper.dart';
import '../../../../core/network/api_result.dart';
import '../../domain/entities/report_column.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/entities/report_response.dart';
import '../../domain/entities/report_type.dart';

final reportsRemoteDataSourceProvider = Provider<ReportsRemoteDataSource>((
  ref,
) {
  final apiClient = ref.watch(apiClientProvider);
  final exceptionMapper = ref.watch(apiExceptionMapperProvider);
  return DioReportsRemoteDataSource(
    apiClient: apiClient,
    exceptionMapper: exceptionMapper,
  );
});

abstract interface class ReportsRemoteDataSource {
  Future<ApiResult<ReportResponse>> runReport({
    required ReportType reportType,
    required ReportFilters filters,
  });
}

class DioReportsRemoteDataSource implements ReportsRemoteDataSource {
  DioReportsRemoteDataSource({
    required ApiClient apiClient,
    required ApiExceptionMapper exceptionMapper,
  }) : _apiClient = apiClient,
       _exceptionMapper = exceptionMapper;

  final ApiClient _apiClient;
  final ApiExceptionMapper _exceptionMapper;

  @override
  Future<ApiResult<ReportResponse>> runReport({
    required ReportType reportType,
    required ReportFilters filters,
  }) async {
    try {
      final response = await _apiClient.get<Object?>(
        reportType.path,
        queryParameters: filters.toQueryParameters(),
      );
      final payload = _extractPayload(response.data);
      return ApiSuccess(
        ReportResponse(
          titleKey:
              payload['titleKey'] as String? ?? payload['title'] as String?,
          columns: _extractColumns(payload['columns']),
          data: _extractData(payload),
        ),
      );
    } catch (error) {
      return ApiError(_exceptionMapper.map(error));
    }
  }

  Map<String, dynamic> _extractPayload(Object? payload) {
    if (payload is Map<String, dynamic>) {
      if (_looksLikeReportPayload(payload)) {
        return payload;
      }

      for (final key in const ['data', 'result', 'item']) {
        final value = payload[key];
        if (value is Map<String, dynamic>) {
          final nested = _extractPayload(value);
          if (_looksLikeReportPayload(nested)) {
            return nested;
          }
        }
      }

      return payload;
    }

    throw const AppFailureException(
      UnknownFailure('Unexpected report response structure.'),
    );
  }

  bool _looksLikeReportPayload(Map<String, dynamic> payload) {
    return payload.containsKey('columns') ||
        payload.containsKey('titleKey') ||
        payload.containsKey('data') ||
        payload.containsKey('content');
  }

  List<ReportColumn> _extractColumns(Object? rawColumns) {
    if (rawColumns is! List) {
      return const [];
    }

    return rawColumns
        .whereType<Map<String, dynamic>>()
        .map(ReportColumn.fromJson)
        .where((column) => column.key.isNotEmpty)
        .toList();
  }

  Object? _extractData(Map<String, dynamic> payload) {
    if (payload.containsKey('data')) {
      return payload['data'];
    }
    if (payload.containsKey('content')) {
      return <String, dynamic>{'content': payload['content']};
    }
    if (payload.containsKey('items')) {
      return payload['items'];
    }
    if (payload.containsKey('results')) {
      return payload['results'];
    }
    return null;
  }
}
