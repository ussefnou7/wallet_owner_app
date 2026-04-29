import '../../domain/entities/renewal_request.dart';
import '../../domain/entities/renewal_request_item.dart';
import '../../domain/entities/renewal_request_payload.dart';
import '../../domain/entities/renewal_request_result.dart';
import '../../domain/repositories/renewal_requests_repository.dart';

class MockRenewalRequestsRepository implements RenewalRequestsRepository {
  final List<RenewalRequestItem> _requests = [];

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

  @override
  Future<List<RenewalRequestItem>> getMyRenewalRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return List.unmodifiable(_requests);
  }

  @override
  Future<void> createRenewalRequest(RenewalRequestPayload payload) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final now = DateTime.now();
    _requests.insert(
      0,
      RenewalRequestItem(
        requestId: 'RR-${now.millisecondsSinceEpoch}',
        tenantId: 'tenant-demo',
        requestedBy: 'owner',
        phoneNumber: payload.phoneNumber,
        amount: payload.amount,
        periodMonths: payload.periodMonths,
        status: 'PENDING',
        createdAt: now,
        updatedAt: now,
      ),
    );
  }
}
