import '../../domain/entities/renewal_request.dart';
import '../../domain/entities/renewal_request_result.dart';
import '../../domain/repositories/renewal_requests_repository.dart';

class MockRenewalRequestsRepository implements RenewalRequestsRepository {
  @override
  Future<RenewalRequestResult> submitRequest(RenewalRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));

    final targetPlanName = switch (request.targetPlanId) {
      'starter' => 'Starter',
      'growth' => 'Growth',
      'enterprise' => 'Enterprise',
      _ => 'Selected Plan',
    };

    return RenewalRequestResult(
      requestId: 'RR-${DateTime.now().millisecondsSinceEpoch}',
      targetPlanName: targetPlanName,
    );
  }
}
