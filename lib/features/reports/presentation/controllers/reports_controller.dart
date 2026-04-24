import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/report_filters.dart';
import '../../domain/entities/report_response.dart';
import '../../domain/entities/report_type.dart';
import '../../domain/repositories/reports_repository.dart';

final reportsSelectedTypeProvider = StateProvider<ReportType>(
  (ref) => ReportType.transactionSummary,
);

final reportsAppliedFiltersProvider = StateProvider<ReportFilters>(
  (ref) => ReportFilters.empty,
);

final reportsControllerProvider =
    AsyncNotifierProvider<ReportsController, ReportResponse>(
      ReportsController.new,
    );

class ReportsController extends AsyncNotifier<ReportResponse> {
  @override
  Future<ReportResponse> build() {
    final reportType = ref.watch(reportsSelectedTypeProvider);
    final filters = ref.watch(reportsAppliedFiltersProvider);

    return _runReport(reportType: reportType, filters: filters);
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final reportType = ref.read(reportsSelectedTypeProvider);
      final filters = ref.read(reportsAppliedFiltersProvider);
      return _runReport(reportType: reportType, filters: filters);
    });
  }

  void selectReportType(
    ReportType reportType, {
    ReportFilters? currentFilters,
  }) {
    final ReportFilters baseFilters;
    if (currentFilters != null) {
      baseFilters = currentFilters;
    } else {
      baseFilters = ref.read(reportsAppliedFiltersProvider);
    }
    final sanitizedFilters = baseFilters.sanitizedFor(reportType);

    ref.read(reportsSelectedTypeProvider.notifier).state = reportType;
    ref.read(reportsAppliedFiltersProvider.notifier).state = sanitizedFilters;
  }

  void applyFilters(ReportFilters filters) {
    final reportType = ref.read(reportsSelectedTypeProvider);
    ref.read(reportsAppliedFiltersProvider.notifier).state = filters
        .sanitizedFor(reportType);
  }

  void clearFilters() {
    final reportType = ref.read(reportsSelectedTypeProvider);
    ref.read(reportsAppliedFiltersProvider.notifier).state = ReportFilters.empty
        .sanitizedFor(reportType);
  }

  Future<ReportResponse> _runReport({
    required ReportType reportType,
    required ReportFilters filters,
  }) {
    final repository = ref.read(reportsRepositoryProvider);
    return repository.runReport(reportType: reportType, filters: filters);
  }
}
