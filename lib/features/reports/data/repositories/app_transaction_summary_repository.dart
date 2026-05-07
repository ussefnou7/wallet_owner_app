import '../../../../core/network/api_result.dart';
import '../../domain/entities/transaction_summary_filters.dart';
import '../../domain/entities/transaction_summary_response.dart';
import '../../domain/repositories/transaction_summary_repository.dart';
import '../services/transaction_summary_remote_data_source.dart';

class AppTransactionSummaryRepository implements TransactionSummaryRepository {
  AppTransactionSummaryRepository({
    required TransactionSummaryRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final TransactionSummaryRemoteDataSource _remoteDataSource;

  @override
  Future<TransactionSummaryResponse> getTransactionSummary({
    required TransactionSummaryFilters filters,
  }) {
    return _remoteDataSource
        .getTransactionSummary(filters: filters)
        .then(_unwrap);
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
