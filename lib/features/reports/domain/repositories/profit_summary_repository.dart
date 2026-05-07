import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/profit_summary_filters.dart';
import '../entities/profit_summary_response.dart';

final profitSummaryRepositoryProvider = Provider<ProfitSummaryRepository>((
  ref,
) {
  throw UnimplementedError(
    'profitSummaryRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class ProfitSummaryRepository {
  Future<ProfitSummaryResponse> getProfitSummary({
    required ProfitSummaryFilters filters,
  });
}
