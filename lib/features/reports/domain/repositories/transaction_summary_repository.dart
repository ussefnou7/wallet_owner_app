import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/transaction_summary_filters.dart';
import '../entities/transaction_summary_response.dart';

final transactionSummaryRepositoryProvider =
    Provider<TransactionSummaryRepository>((ref) {
      throw UnimplementedError(
        'transactionSummaryRepositoryProvider must be overridden at bootstrap',
      );
    });

abstract interface class TransactionSummaryRepository {
  Future<TransactionSummaryResponse> getTransactionSummary({
    required TransactionSummaryFilters filters,
  });
}
