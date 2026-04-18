import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/renewal_request.dart';
import '../entities/renewal_request_result.dart';

final renewalRequestsRepositoryProvider = Provider<RenewalRequestsRepository>((
  ref,
) {
  throw UnimplementedError(
    'renewalRequestsRepositoryProvider must be overridden at bootstrap',
  );
});

abstract interface class RenewalRequestsRepository {
  Future<RenewalRequestResult> submitRequest(RenewalRequest request);
}
