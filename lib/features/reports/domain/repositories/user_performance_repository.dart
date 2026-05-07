import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/user_performance_filters.dart';
import '../entities/user_performance_response.dart';

final userPerformanceRepositoryProvider = Provider<UserPerformanceRepository>((
  ref,
) {
  throw UnimplementedError(
    'userPerformanceRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class UserPerformanceRepository {
  Future<UserPerformanceResponse> getUserPerformance({
    required UserPerformanceFilters filters,
  });
}
