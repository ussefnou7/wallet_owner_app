import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/report_filters.dart';
import '../entities/report_response.dart';
import '../entities/report_type.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>((ref) {
  throw UnimplementedError(
    'reportsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class ReportsRepository {
  Future<ReportResponse> runReport({
    required ReportType reportType,
    required ReportFilters filters,
  });
}
