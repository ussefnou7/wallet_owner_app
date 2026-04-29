import '../../../../core/network/api_result.dart';
import '../../domain/entities/renewal_request.dart';
import '../../domain/entities/renewal_request_item.dart';
import '../../domain/entities/renewal_request_payload.dart';
import '../../domain/entities/renewal_request_result.dart';
import '../../domain/repositories/renewal_requests_repository.dart';
import '../models/renewal_request_payload_model.dart';
import '../services/renewal_remote_data_source.dart';

class AppRenewalRequestsRepository implements RenewalRequestsRepository {
  const AppRenewalRequestsRepository({
    required RenewalRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final RenewalRemoteDataSource _remoteDataSource;

  @override
  Future<RenewalRequestResult> submitRequest(RenewalRequest request) async {
    // This maps the existing UI model to the new backend contract
    // NOTE: The backend contract doesn't use the 'note' or 'targetPlanId' directly as per instructions,
    // it expects phoneNumber, amount, and periodMonths.
    // This repository serves as the bridge.

    // For now, since the request renewal UI was already there but mocked,
    // and we need to implement the NEW contract:
    // We will use the implementation that satisfies the NEW contract in a new controller.

    throw UnimplementedError(
      'Use the new specific renewal flow for the new contract',
    );
  }

  @override
  Future<List<RenewalRequestItem>> getMyRenewalRequests() {
    return _remoteDataSource.getMyRenewalRequests().then(_unwrap);
  }

  @override
  Future<void> createRenewalRequest(RenewalRequestPayload payload) {
    return _remoteDataSource.createRenewalRequest(
      RenewalRequestPayloadModel(
        phoneNumber: payload.phoneNumber,
        amount: payload.amount,
        periodMonths: payload.periodMonths,
      ),
    );
  }

  T _unwrap<T>(ApiResult<T> result) {
    return result.when(
      success: (data) => data,
      failure: (failure) => throw failure,
    );
  }
}
