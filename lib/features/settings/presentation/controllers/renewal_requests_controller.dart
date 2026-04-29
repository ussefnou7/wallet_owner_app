import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/renewal_request_item.dart';
import '../../domain/repositories/renewal_requests_repository.dart';

final renewalRequestsControllerProvider =
    AsyncNotifierProvider<RenewalRequestsController, List<RenewalRequestItem>>(
      RenewalRequestsController.new,
    );

class RenewalRequestsController
    extends AsyncNotifier<List<RenewalRequestItem>> {
  @override
  Future<List<RenewalRequestItem>> build() async {
    final repository = ref.watch(renewalRequestsRepositoryProvider);
    return repository.getMyRenewalRequests();
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(renewalRequestsRepositoryProvider);
      return repository.getMyRenewalRequests();
    });
  }
}
