import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/renewal_request.dart';
import '../entities/renewal_request_item.dart';
import '../entities/renewal_request_payload.dart';
import '../entities/renewal_request_result.dart';

final renewalRequestsRepositoryProvider = Provider<RenewalRequestsRepository>((
  ref,
) {
  throw UnimplementedError(
    'renewalRequestsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class RenewalRequestsRepository {
  /// Deprecated: used for the old mock flow
  Future<RenewalRequestResult> submitRequest(RenewalRequest request);

  Future<List<RenewalRequestItem>> getMyRenewalRequests();

  /// New flow for the real backend contract
  Future<void> createRenewalRequest(RenewalRequestPayload payload);
}
